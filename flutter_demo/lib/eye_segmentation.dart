import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class EyeSegmentationScreen extends StatefulWidget {
  const EyeSegmentationScreen({super.key});

  @override
  State<EyeSegmentationScreen> createState() => _EyeSegmentationState();
}

class _EyeSegmentationState extends State<EyeSegmentationScreen> {
  static const imageSizeFace = 96;
  static const imageSizeEyeSegmentation = 48;
  var _frameCounter = 0;
  Interpreter? _faceDetectionInterpreter;
  Interpreter? _eyeSegmentationInterpreter;
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  bool _isDetecting = false;
  List<double>? _detectionResult;
  List<EyeSegment> _eyeSegments = [];
  var _showBoundingBox = true;
  ui.Image? _sombrero;
  ui.Image? _glasses;
  final _timings = Timings();
  final _screenshotController = ScreenshotController();

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
    _glasses = await loadUiImage('assets/images/glasses.png');
  }

  Future<ui.Image> loadUiImage(String assetPath) async {
    final data = await rootBundle.load(assetPath);
    final list = Uint8List.view(data.buffer);
    final completer = Completer<ui.Image>();
    ui.decodeImageFromList(list, completer.complete);
    return completer.future;
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    _cameraController = CameraController(
      _cameras.firstWhere((e) => e.lensDirection == CameraLensDirection.front),
      ResolutionPreset.low,
    );
    await _cameraController?.initialize();
    if (!mounted) return;
    setState(() {});
    _startListeningForCameraUpdates();
  }

  Future<void> _startListeningForCameraUpdates() async {
    await _cameraController?.initialize();

    _cameraController?.startImageStream((CameraImage image) async {
      if (!mounted || _isDetecting) return;
      _frameCounter++;
      if (_frameCounter % 2 != 0) return;
      _frameCounter = 0;
      _isDetecting = true;
      await _runModelsOnFrame(image);
      if (!mounted) return;
      setState(() {});
      _isDetecting = false;
    });
  }

  Future<void> _stopListeningForCameraUpdates() async {
    _cameraController?.stopImageStream();
  }

  Future<void> _takePicture() async {
    try {
      final image = await _screenshotController.capture(
        delay: const Duration(milliseconds: 1),
        pixelRatio: MediaQuery.of(context).devicePixelRatio,
      );
      if (image == null) return;
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = await File('${directory.path}/${Random().nextDouble().toString().split('.').last}.png').create();
      await imagePath.writeAsBytes(image);
      await Share.shareXFiles([XFile(imagePath.path)]);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Image saved to ${imagePath.path}'),
      ));
    } catch (e) {
      if (kDebugMode) {
        print('Error taking picture: $e');
      }
    }
  }

  Future<void> _runModelsOnFrame(CameraImage image) async {
    if (_faceDetectionInterpreter == null || _eyeSegmentationInterpreter == null) {
      return;
    }
    _timings.start = DateTime.now();
    final imageConverted = _convertImage(image, imageSizeFace);
    _timings.imageConversion = DateTime.now();
    final inputImageDetection = _preProcessImage(imageConverted);
    _timings.imageProcessing = DateTime.now();
    final inputDetection = inputImageDetection.buffer.asFloat32List();
    var inputShapeDetection = _faceDetectionInterpreter!.getInputTensor(0).shape;
    if (inputShapeDetection.length != 4 || inputShapeDetection[0] != 1) {
      throw StateError("Model expects a 4D input tensor with batch size 1.");
    }
    final inputTensorDetection = inputDetection.reshape([1, inputShapeDetection[1], inputShapeDetection[2], inputShapeDetection[3]]);
    var outputDetection = List.filled(_faceDetectionInterpreter!.getOutputTensor(0).shape[1], 0).reshape([1, 4]);
    try {
      _faceDetectionInterpreter!.run(inputTensorDetection, outputDetection);
    } catch (e) {
      if (kDebugMode) {
        print("Error during inference face detection: $e");
      }
      rethrow;
    }
    _timings.faceDetection = DateTime.now();
    _detectionResult = outputDetection[0];
    final faceLocation = [
      min<double>(outputDetection[0][0], outputDetection[0][2]) * imageSizeFace,
      min<double>(outputDetection[0][1], outputDetection[0][3]) * imageSizeFace,
      max<double>(outputDetection[0][0], outputDetection[0][2]) * imageSizeFace,
      max<double>(outputDetection[0][1], outputDetection[0][3]) * imageSizeFace,
    ];
    final faceImage = img.copyCrop(
      imageConverted,
      x: faceLocation[0].toInt(),
      y: faceLocation[1].toInt(),
      width: faceLocation[2].toInt() - faceLocation[0].toInt(),
      height: faceLocation[3].toInt() - faceLocation[1].toInt(),
    );
    if (faceImage.width == 0 || faceImage.height == 0) return;
    final resizedFaceImage = img.copyResize(faceImage, width: imageSizeEyeSegmentation, height: imageSizeEyeSegmentation);
    final inputFaceImage = _preProcessImage(resizedFaceImage);
    final inputTensorSegmentation = inputFaceImage.buffer.asFloat32List();
    var inputShapeSegmentation = _eyeSegmentationInterpreter!.getInputTensor(0).shape;
    if (inputShapeSegmentation.length != 4 || inputShapeSegmentation[0] != 1) {
      throw StateError("Model expects a 4D input tensor with batch size 1.");
    }
    final inputTensorSegmentationReshaped = inputTensorSegmentation.reshape([1, inputShapeSegmentation[1], inputShapeSegmentation[2], inputShapeSegmentation[3]]);
    var outputSegmentation = List.filled(imageSizeEyeSegmentation * imageSizeEyeSegmentation * 2, 0).reshape([1, imageSizeEyeSegmentation, imageSizeEyeSegmentation, 2]);
    _timings.cuttingAndProcessing = DateTime.now();
    try {
      _eyeSegmentationInterpreter!.run(inputTensorSegmentationReshaped, outputSegmentation);
    } catch (e) {
      if (kDebugMode) {
        print("Error during inference eye segmentation: $e");
      }
      rethrow;
    }
    _timings.eyeSegmentation = DateTime.now();
    final eyeSegmentation = List.generate(
      imageSizeEyeSegmentation,
      (y) => List.generate(
        imageSizeEyeSegmentation,
        (x) {
          // Select the class with the highest probability (0: background, 1: eye)
          return outputSegmentation[0][y][x][1] > outputSegmentation[0][y][x][0] ? 1 : 0;
        },
      ),
    );
    _eyeSegments = findEyeSegments(
      eyeSegmentation,
      faceLocation[0] / imageSizeFace,
      faceLocation[1] / imageSizeFace,
      (faceLocation[2] - faceLocation[0]) / imageSizeFace,
      (faceLocation[3] - faceLocation[1]) / imageSizeFace,
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
    for (var y = 0; y < imageSizeEyeSegmentation; y++) {
      for (var x = 0; x < imageSizeEyeSegmentation; x++) {
        if (eyeSegmentation[y][x] == 1) {
          List<List<int>> eyeRegion = getEyeRegion(y, x, eyeSegmentation);
          if (eyeRegion.isNotEmpty) {
            int sumX = eyeRegion.map((p) => p[0]).reduce((a, b) => a + b);
            int sumY = eyeRegion.map((p) => p[1]).reduce((a, b) => a + b);
            int count = eyeRegion.length;
            eyeSegments.add(EyeSegment(
              x: sumX / count / imageSizeEyeSegmentation * faceScaleX + faceLocationX,
              y: sumY / count / imageSizeEyeSegmentation * faceScaleY + faceLocationY,
              pixels: eyeRegion.map((p) => [p[0].toDouble(), p[1].toDouble()]).toList(),
            ));
          }
        }
      }
    }
    eyeSegments.sort((a, b) => b.amountOfPixels.compareTo(a.amountOfPixels));
    final eyeSegmentsFiltered = <EyeSegment>[];
    for (var i = 0; i < eyeSegments.length; i++) {
      if (eyeSegmentsFiltered.any((e) => e.x == eyeSegments[i].x && e.y == eyeSegments[i].y)) {
        continue;
      }
      eyeSegments[i].pixels = eyeSegments[i]
          .pixels
          .map((p) => [
                p[0] / imageSizeEyeSegmentation * faceScaleX + faceLocationX,
                p[1] / imageSizeEyeSegmentation * faceScaleY + faceLocationY,
              ])
          .toList();
      eyeSegmentsFiltered.add(eyeSegments[i]);
      if (eyeSegmentsFiltered.length >= 2) {
        break;
      }
    }
    return eyeSegmentsFiltered;
  }

  List<List<int>> getEyeRegion(int startY, int startX, List<List<int>> eyeSegmentation) {
    int imageSize = eyeSegmentation.length;
    List<List<int>> eyeRegion = [];
    if (eyeSegmentation[startY][startX] == 0) {
      return eyeRegion;
    }
    Queue<List<int>> queue = Queue();
    queue.add([startY, startX]);
    Set<String> visited = {};
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

  img.Image _convertImage(CameraImage cameraImage, int imageSize) {
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
          Screenshot(
            controller: _screenshotController,
            child: Stack(
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
                  Positioned.fill(
                    child: CustomPaint(
                      painter: EyesPainter(
                        eyeSegments: _eyeSegments,
                        showBoundingBox: _showBoundingBox,
                        glasses: _glasses,
                        imageSizeFace: imageSizeFace,
                        faceLocationTopLeft: Offset(
                          min<double>(_detectionResult![0], _detectionResult![2]),
                          min<double>(_detectionResult![1], _detectionResult![3]),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
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
          Row(
            children: [
              ElevatedButton(
                onPressed: () async {
                  await _stopListeningForCameraUpdates();
                  await _cameraController?.setDescription(_cameraController?.description == null || _cameraController?.description.lensDirection == CameraLensDirection.front
                      ? _cameras.firstWhere((e) => e.lensDirection == CameraLensDirection.back)
                      : _cameras.firstWhere((e) => e.lensDirection == CameraLensDirection.front));
                  _startListeningForCameraUpdates();
                },
                child: Text('Switch camera (${_cameraController?.description.name})'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _takePicture,
                child: const Text('Take picture'),
              ),
            ],
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

class EyesPainter extends CustomPainter {
  final List<EyeSegment> eyeSegments;
  final bool showBoundingBox;
  final ui.Image? glasses;
  final int imageSizeFace;
  final Offset faceLocationTopLeft;

  EyesPainter({
    required this.eyeSegments,
    required this.showBoundingBox,
    required this.glasses,
    required this.imageSizeFace,
    required this.faceLocationTopLeft,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (showBoundingBox) {
      final paint = Paint()
        ..color = Colors.blue
        ..style = PaintingStyle.fill;
      for (var eyeSegment in eyeSegments) {
        canvas.drawCircle(Offset(eyeSegment.x * size.width, eyeSegment.y * size.height), 4, paint);
      }
    } else {
      if (glasses == null || eyeSegments.length != 2) return;
      final width = (eyeSegments[1].x * size.width - eyeSegments[0].x * size.width).abs() * 2;
      final height = width * glasses!.height / glasses!.width;
      var angle = atan2(
        (eyeSegments[1].y - eyeSegments[0].y) * size.height,
        (eyeSegments[1].x - eyeSegments[0].x) * size.width,
      );

      if (angle > pi / 2) {
        angle -= pi;
      } else if (angle < -pi / 2) {
        angle += pi;
      }

      final centerX = (eyeSegments[0].x + eyeSegments[1].x) / 2 * size.width;
      final centerY = (eyeSegments[0].y + eyeSegments[1].y) / 2 * size.height;
      canvas.save();
      canvas.translate(centerX, centerY);
      canvas.rotate(angle);
      canvas.drawImageRect(
        glasses!,
        Rect.fromLTWH(0, 0, glasses!.width.toDouble(), glasses!.height.toDouble()),
        Rect.fromLTWH(-width / 2, -height / 2, width, height),
        Paint(),
      );
      canvas.restore();
      // final pixels = [...eyeSegments.first.pixels, ...eyeSegments.last.pixels];
      // final paint = Paint()
      //   ..color = Colors.red.withOpacity(0.5)
      //   ..style = PaintingStyle.fill;
      // for (var pixel in pixels) {
      //   canvas.drawCircle(
      //     Offset(pixel[0] * size.width, pixel[1] * size.height),
      //     1 / imageSizeFace * max(size.width, size.height),
      //     paint,
      //   );
      // }
    }
  }

  @override
  bool shouldRepaint(EyesPainter oldDelegate) => true;
}

class EyeSegment {
  final double x;
  final double y;
  List<List<double>> pixels;
  late final int amountOfPixels;

  EyeSegment({
    required this.x,
    required this.y,
    required this.pixels,
  }) {
    amountOfPixels = pixels.length;
  }
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
