import 'dart:async';
import 'dart:collection';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class EyeSegmentationScreen extends StatefulWidget {
  const EyeSegmentationScreen({super.key});

  @override
  State<EyeSegmentationScreen> createState() => _EyeSegmentationState();
}

class _EyeSegmentationState extends State<EyeSegmentationScreen> {
  static const imageSize = 96;
  var _frameCounter = 0;
  Interpreter? _faceDetectionInterpreter;
  Interpreter? _eyeSegmentationInterpreter;
  CameraController? _cameraController;
  bool _isDetecting = false;
  List<double>? _detectionResult;
  List<EyeSegment> _eyeSegments = [];
  var _showBoundingBox = true;
  ui.Image? _sombrero;
  final _timings = Timings();

  _EyeSegmentationState() {
    _initInterpreters();
    _initializeCamera();
    _initializeProps();
  }

  Future<void> _initInterpreters() async {
    _faceDetectionInterpreter = await Interpreter.fromAsset('assets/models/face_detection.tflite');
    _eyeSegmentationInterpreter = await Interpreter.fromAsset('assets/models/eye_segmentation.tflite');
  }

  Future<void> _initializeProps() async {
    _sombrero = await loadUiImage('assets/images/sombrero.png');
  }

  Future<ui.Image> loadUiImage(String assetPath) async {
    final data = await rootBundle.load(assetPath);
    final list = Uint8List.view(data.buffer);
    final completer = Completer<ui.Image>();
    ui.decodeImageFromList(list, completer.complete);
    return completer.future;
  }

  void _initializeCamera() async {
    final cameras = await availableCameras();
    _cameraController = CameraController(
      cameras.firstWhere((e) => e.lensDirection == CameraLensDirection.front),
      ResolutionPreset.low,
    );
    await _cameraController?.initialize();

    if (!mounted) return;
    setState(() {});

    _cameraController?.startImageStream((CameraImage image) async {
      if (_isDetecting) return;
      _frameCounter++;
      if (_frameCounter % 2 != 0) return;
      _frameCounter = 0;
      _isDetecting = true;
      await _runModelsOnFrame(image);
      setState(() {});
      _isDetecting = false;
    });
  }

  Future<void> _runModelsOnFrame(CameraImage image) async {
    if (_faceDetectionInterpreter == null || _eyeSegmentationInterpreter == null) {
      return;
    }
    _timings.start = DateTime.now();
    final imageConverted = _convertImage(image);
    _timings.imageConversion = DateTime.now();
    final inputImageDetection = _preProcessImage(imageConverted);
    final inputDetection = inputImageDetection.buffer.asFloat32List();
    var inputShapeDetection = _faceDetectionInterpreter!.getInputTensor(0).shape;
    if (inputShapeDetection.length != 4 || inputShapeDetection[0] != 1) {
      throw StateError("Model expects a 4D input tensor with batch size 1.");
    }
    final inputTensorDetection = inputDetection.reshape([1, inputShapeDetection[1], inputShapeDetection[2], inputShapeDetection[3]]);
    var outputDetection = List.filled(_faceDetectionInterpreter!.getOutputTensor(0).shape[1], 0).reshape([1, 4]);
    _timings.imageProcessing = DateTime.now();
    try {
      _faceDetectionInterpreter!.run(inputTensorDetection, outputDetection);
    } catch (e) {
      print("Error during inference face detection: $e");
      rethrow;
    }
    _timings.faceDetection = DateTime.now();
    _detectionResult = outputDetection[0];
    final faceLocation = [
      min<double>(outputDetection[0][0], outputDetection[0][2]) * imageSize,
      min<double>(outputDetection[0][1], outputDetection[0][3]) * imageSize,
      max<double>(outputDetection[0][0], outputDetection[0][2]) * imageSize,
      max<double>(outputDetection[0][1], outputDetection[0][3]) * imageSize,
    ];
    final faceImage = img.copyCrop(
      imageConverted,
      x: faceLocation[0].toInt(),
      y: faceLocation[1].toInt(),
      width: faceLocation[2].toInt() - faceLocation[0].toInt(),
      height: faceLocation[3].toInt() - faceLocation[1].toInt(),
    );
    if (faceImage.width == 0 || faceImage.height == 0) return;
    final resizedFaceImage = img.copyResize(faceImage, width: imageSize, height: imageSize);
    final inputFaceImage = _preProcessImage(resizedFaceImage);
    final inputTensorSegmentation = inputFaceImage.buffer.asFloat32List();
    var inputShapeSegmentation = _eyeSegmentationInterpreter!.getInputTensor(0).shape;
    if (inputShapeSegmentation.length != 4 || inputShapeSegmentation[0] != 1) {
      throw StateError("Model expects a 4D input tensor with batch size 1.");
    }
    final inputTensorSegmentationReshaped = inputTensorSegmentation.reshape([1, inputShapeSegmentation[1], inputShapeSegmentation[2], inputShapeSegmentation[3]]);
    var outputSegmentation = List.filled(imageSize * imageSize * 2, 0).reshape([1, imageSize, imageSize, 2]);
    _timings.cuttingAndProcessing = DateTime.now();
    try {
      _eyeSegmentationInterpreter!.run(inputTensorSegmentationReshaped, outputSegmentation);
    } catch (e) {
      print("Error during inference eye segmentation: $e");
      rethrow;
    }
    _timings.eyeSegmentation = DateTime.now();
    final eyeSegmentation = List.generate(
      imageSize,
      (y) => List.generate(
        imageSize,
        (x) {
          // Select the class with the highest probability (0: background, 1: eye)
          return outputSegmentation[0][y][x][1] > outputSegmentation[0][y][x][0] ? 1 : 0;
        },
      ),
    );
    _eyeSegments = findEyeSegments(
      eyeSegmentation,
      faceLocation[0] / imageSize,
      faceLocation[1] / imageSize,
      (faceLocation[2] - faceLocation[0]) / imageSize,
      (faceLocation[3] - faceLocation[1]) / imageSize,
    );
    _timings.postProcessing = DateTime.now();
  }

  List<EyeSegment> findEyeSegments(
    List<List<int>> eyeSegmentation,
    double faceLocationX,
    double faceLocationY,
    double faceScaleX,
    double faceScaleY,
  ) {
    List<EyeSegment> eyeSegments = [];

    // Loop through the binary mask and find clusters of pixels
    for (var y = 0; y < imageSize; y++) {
      for (var x = 0; x < imageSize; x++) {
        if (eyeSegmentation[y][x] == 1) {
          List<List<int>> eyeRegion = getEyeRegion(y, x, eyeSegmentation);
          if (eyeRegion.isNotEmpty) {
            int sumX = eyeRegion.map((p) => p[0]).reduce((a, b) => a + b);
            int sumY = eyeRegion.map((p) => p[1]).reduce((a, b) => a + b);
            int count = eyeRegion.length;
            var mask = List.generate(imageSize, (y) => List.generate(imageSize, (x) => 0));
            for (var pixel in eyeRegion) {
              mask[pixel[1]][pixel[0]] = 1;
            }
            eyeSegments.add(EyeSegment(
              x: sumX / count / imageSize * faceScaleX + faceLocationX,
              y: sumY / count / imageSize * faceScaleY + faceLocationY,
              pixels: eyeRegion,
            ));
          }
        }
      }
    }

    return eyeSegments;
  }

  List<List<int>> getEyeRegion(int startY, int startX, List<List<int>> eyeSegmentation) {
    // Dimensions of the image
    int imageSize = eyeSegmentation.length;

    // List to store the pixels belonging to the current eye region
    List<List<int>> eyeRegion = [];

    // Check if the starting pixel is part of an eye region
    if (eyeSegmentation[startY][startX] == 0) {
      return eyeRegion; // Return empty if the starting point is not an eye pixel
    }

    // A queue for flood-fill algorithm (BFS)
    Queue<List<int>> queue = Queue();
    queue.add([startY, startX]);

    // Set to keep track of visited pixels
    Set<String> visited = {};

    // Directions for moving in 4-connected neighbors (up, down, left, right)
    List<List<int>> directions = [
      [-1, 0], // Up
      [1, 0], // Down
      [0, -1], // Left
      [0, 1] // Right
    ];

    while (queue.isNotEmpty) {
      var pixel = queue.removeFirst();
      int y = pixel[0];
      int x = pixel[1];

      // Skip if the pixel is already visited
      if (visited.contains('$y,$x')) continue;
      visited.add('$y,$x');

      // Add the pixel to the eye region
      eyeRegion.add([x, y]);

      // Check 4-connected neighbors
      for (var direction in directions) {
        int newY = y + direction[0];
        int newX = x + direction[1];

        // Check if the neighbor is within bounds and part of the eye region
        if (newY >= 0 && newY < imageSize && newX >= 0 && newX < imageSize) {
          if (eyeSegmentation[newY][newX] == 1 && !visited.contains('$newY,$newX')) {
            queue.add([newY, newX]);
          }
        }
      }
    }

    return eyeRegion;
  }

  Float32List _preProcessImage(img.Image convertedImage) {
    List<int> resizedBytes = convertedImage.getBytes(order: img.ChannelOrder.rgb);
    Float32List normalizedBytes = Float32List(resizedBytes.length);
    for (int i = 0; i < resizedBytes.length; i++) {
      normalizedBytes[i] = resizedBytes[i] / 255.0;
    }
    return normalizedBytes;
  }

  img.Image _convertImage(CameraImage cameraImage) {
    final width = cameraImage.width;
    final height = cameraImage.height;
    final imgImage = img.Image(width: width, height: height);

    // Get Y, U, and V planes from CameraImage
    final planeY = cameraImage.planes[0];
    final planeU = cameraImage.planes[1];
    final planeV = cameraImage.planes[2];

    final yBuffer = planeY.bytes;
    final uBuffer = planeU.bytes;
    final vBuffer = planeV.bytes;

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final int yIndex = y * planeY.bytesPerRow + x;
        final int uvIndex = (y ~/ 2) * planeU.bytesPerRow + (x ~/ 2) * planeU.bytesPerPixel!;

        final yValue = yBuffer[yIndex];
        final uValue = uBuffer[uvIndex] - 128;
        final vValue = vBuffer[uvIndex] - 128;

        final r = (yValue + 1.370705 * vValue).clamp(0, 255).toInt();
        final g = (yValue - 0.337633 * uValue - 0.698001 * vValue).clamp(0, 255).toInt();
        final b = (yValue + 1.732446 * uValue).clamp(0, 255).toInt();

        imgImage.setPixel(x, y, img.ColorFloat32.rgb(r, g, b));
      }
    }
    final img.Image resizedImage = img.copyResize(imgImage, width: imageSize, height: imageSize);
    final img.Image rotatedImage = img.copyRotate(resizedImage, angle: -90); // Rotate the image to match the training orientation
    return img.flipHorizontal(rotatedImage);
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _faceDetectionInterpreter?.close();
    _eyeSegmentationInterpreter?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AspectRatio(
            aspectRatio: 1 / (_cameraController?.value.aspectRatio ?? 1),
            child: LayoutBuilder(
              builder: (context, constraints) => Stack(
                children: [
                  if (_cameraController != null && _cameraController!.value.isInitialized)
                    CameraPreview(
                      _cameraController!,
                    ),
                  if (_faceDetectionInterpreter == null || _eyeSegmentationInterpreter == null) ...[
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ] else if (_detectionResult != null) ...[
                    Positioned.fill(
                      child: CustomPaint(
                        painter: BoundingBoxPainter(
                          _detectionResult!,
                          showBoundingBox: _showBoundingBox,
                          sombrero: _sombrero,
                        ),
                      ),
                    ),
                    for (var eyeSegment in _eyeSegments) ...[
                      Positioned(
                        left: eyeSegment.x * constraints.maxWidth,
                        top: eyeSegment.y * constraints.maxHeight,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => setState(() => _showBoundingBox = !_showBoundingBox),
            child: Row(
              children: [
                Checkbox(
                  value: _showBoundingBox,
                  onChanged: (value) => setState(() => _showBoundingBox = value!),
                ),
                const SizedBox(width: 8),
                const Text('Show bounding box'),
              ],
            ),
          ),
          ..._timings.timings.entries.map((entry) {
            return Container(
              padding: const EdgeInsets.all(8),
              color: Colors.black.withOpacity(0.5),
              child: Text(
                '${entry.key}: ${entry.value}ms',
                style: const TextStyle(color: Colors.white),
              ),
            );
          }),
        ],
      ),
    );
  }
}

// Painter to overlay bounding boxes on the camera preview
class BoundingBoxPainter extends CustomPainter {
  final List<double> result;
  final bool showBoundingBox;
  final ui.Image? sombrero;

  BoundingBoxPainter(
    this.result, {
    required this.showBoundingBox,
    required this.sombrero,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    final left = result[0] * size.width;
    final top = result[1] * size.height;
    final right = result[2] * size.width;
    final bottom = result[3] * size.height;
    if (showBoundingBox) {
      canvas.drawRect(Rect.fromLTRB(left, top, right, bottom), paint);
    } else {
      if (sombrero != null) {
        final sombreroWidth = (right - left) * 2;
        final sombreroHeight = sombreroWidth * sombrero!.height / sombrero!.width;
        canvas.drawImageRect(
          sombrero!,
          Rect.fromLTWH(0, 0, sombrero!.width.toDouble(), sombrero!.height.toDouble()),
          Rect.fromLTWH(left - (sombreroWidth - (right - left)) / 2, top - sombreroHeight * 0.6, sombreroWidth, sombreroHeight),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(BoundingBoxPainter oldDelegate) => true;
}

class EyeSegment {
  final double x;
  final double y;
  final List<List<int>> pixels;

  EyeSegment({
    required this.x,
    required this.y,
    required this.pixels,
  });
}

class Timings {
  DateTime start;
  DateTime imageConversion;
  DateTime imageProcessing;
  DateTime faceDetection;
  DateTime cuttingAndProcessing;
  DateTime eyeSegmentation;
  DateTime postProcessing;

  Timings()
      : start = DateTime.now(),
        imageConversion = DateTime.now(),
        imageProcessing = DateTime.now(),
        faceDetection = DateTime.now(),
        cuttingAndProcessing = DateTime.now(),
        eyeSegmentation = DateTime.now(),
        postProcessing = DateTime.now();

  Map<String, int> get timings => {
        'Image conversion': imageConversion.difference(start).inMilliseconds,
        'Image processing': imageProcessing.difference(imageConversion).inMilliseconds,
        'Face detection': faceDetection.difference(imageProcessing).inMilliseconds,
        'Cutting and processing': cuttingAndProcessing.difference(faceDetection).inMilliseconds,
        'Eye segmentation': eyeSegmentation.difference(cuttingAndProcessing).inMilliseconds,
        'Post processing': postProcessing.difference(eyeSegmentation).inMilliseconds,
      };
}
