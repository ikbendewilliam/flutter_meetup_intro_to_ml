import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class FaceDetectionScreen extends StatefulWidget {
  const FaceDetectionScreen({super.key});

  @override
  State<FaceDetectionScreen> createState() => _FaceDetectionState();
}

class _FaceDetectionState extends State<FaceDetectionScreen> {
  static const imageSize = 96;
  var _frameCounter = 0;
  Interpreter? _interpreter;
  CameraController? _cameraController;
  bool _isDetecting = false;
  List<double>? _detectionResult;
  var _showBoundingBox = true;
  ui.Image? _sombrero;

  _FaceDetectionState() {
    _initInterpreter();
  }

  void _initInterpreter() async {
    _interpreter = await Interpreter.fromAsset('assets/models/face_detection.tflite');
    _initializeCamera();
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
      final results = await _runModelOnFrame(image);
      setState(() {
        _detectionResult = results.first;
      });
      _isDetecting = false;
    });
  }

  Future<List<dynamic>> _runModelOnFrame(CameraImage image) async {
    final inputImage = _preProcessImage(image);
    final input = inputImage.buffer.asFloat32List();
    var inputShape = _interpreter!.getInputTensor(0).shape;
    if (inputShape.length != 4 || inputShape[0] != 1) {
      throw StateError("Model expects a 4D input tensor with batch size 1.");
    }
    final inputTensor = input.reshape([1, inputShape[1], inputShape[2], inputShape[3]]);
    var output = List.filled(_interpreter!.getOutputTensor(0).shape[1], 0).reshape([1, 4]);
    try {
      _interpreter!.run(inputTensor, output);
    } catch (e) {
      print("Error during inference: $e");
      rethrow;
    }
    return output;
  }

  Float32List _preProcessImage(CameraImage image) {
    final img.Image convertedImage = _convertYUV420ToImage(image);
    final img.Image resizedImage = img.copyResize(convertedImage, width: imageSize, height: imageSize);
    final img.Image rotatedImage = img.copyRotate(resizedImage, angle: -90); // Rotate the image to match the training orientation
    final img.Image flippedImage = img.flipHorizontal(rotatedImage);
    List<int> resizedBytes = flippedImage.getBytes(order: img.ChannelOrder.rgb);
    Float32List normalizedBytes = Float32List(resizedBytes.length);
    for (int i = 0; i < resizedBytes.length; i++) {
      normalizedBytes[i] = resizedBytes[i] / 255.0;
    }
    return normalizedBytes;
  }

  img.Image _convertYUV420ToImage(CameraImage cameraImage) {
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

    return imgImage;
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _interpreter?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              if (_cameraController != null && _cameraController!.value.isInitialized) CameraPreview(_cameraController!),
              if (_interpreter == null) ...[
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
              ],
            ],
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
