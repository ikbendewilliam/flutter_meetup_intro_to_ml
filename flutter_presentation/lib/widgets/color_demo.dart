import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class ColorRecognizerDemo extends StatefulWidget {
  const ColorRecognizerDemo({super.key});

  @override
  State<ColorRecognizerDemo> createState() => _ColorRecognizerDemoState();
}

class _ColorRecognizerDemoState extends State<ColorRecognizerDemo> {
  double red = 0;
  double green = 0;
  double blue = 0;
  Interpreter? _interpreter;
  final colorsPredictions = [
    ...Colors.primaries,
    Colors.grey,
    Colors.black,
    Colors.white,
  ].asMap().map((key, value) => MapEntry(value, 0.0));

  @override
  void initState() {
    super.initState();
    _initInterpreter();
  }

  void _initInterpreter() async {
    _interpreter = await Interpreter.fromAsset('assets/models/color_recognizer.tflite');
  }

  void predict() {
    final interpreter = _interpreter;
    if (interpreter == null) return;
    final input = [red / 255, green / 255, blue / 255];
    var output = List.filled(_interpreter!.getOutputTensor(0).shape[1], 0).reshape([1, 21]);
    try {
      _interpreter!.run(input, output);
    } catch (e) {
      if (kDebugMode) {
        print("Error during inference: $e");
      }
      rethrow;
    }
    setState(() {
      for (var i = 0; i < output[0].length; i++) {
        colorsPredictions[colorsPredictions.keys.elementAt(i)] = output[0][i];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Text('Red: ${red.toStringAsFixed(2)}'),
                  Expanded(
                    child: Slider(
                      value: red,
                      onChanged: (value) => setState(() {
                        red = value;
                        predict();
                      }),
                      min: 0,
                      max: 255,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text('Green: ${green.toStringAsFixed(2)}'),
                  Expanded(
                    child: Slider(
                      value: green,
                      onChanged: (value) => setState(() {
                        green = value;
                        predict();
                      }),
                      min: 0,
                      max: 255,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text('Blue: ${blue.toStringAsFixed(2)}'),
                  Expanded(
                    child: Slider(
                      value: blue,
                      onChanged: (value) => setState(() {
                        blue = value;
                        predict();
                      }),
                      min: 0,
                      max: 255,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                color: Color.fromRGBO(red.toInt(), green.toInt(), blue.toInt(), 1),
                height: 32,
              ),
              const SizedBox(height: 16),
              ...(colorsPredictions.entries.toList()..sort((a, b) => -a.value.compareTo(b.value))).map(
                (e) => Container(
                  padding: const EdgeInsets.all(8),
                  width: double.infinity,
                  color: e.key,
                  alignment: Alignment.center,
                  child: Text(
                    '${colorNames[e.key]}: ${(e.value * 100).toStringAsFixed(2)}%',
                    style: TextStyle(
                      fontSize: 16,
                      color: e.key.computeLuminance() > 0.5 ? Colors.black : Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

final colorNames = {
  Colors.red: 'Red',
  Colors.pink: 'Pink',
  Colors.purple: 'Purple',
  Colors.deepPurple: 'Deep purple',
  Colors.indigo: 'Indigo',
  Colors.blue: 'Blue',
  Colors.lightBlue: 'Light blue',
  Colors.cyan: 'Cyan',
  Colors.teal: 'Teal',
  Colors.green: 'Green',
  Colors.lightGreen: 'Light green',
  Colors.lime: 'Lime',
  Colors.yellow: 'Yellow',
  Colors.amber: 'Amber',
  Colors.orange: 'Orange',
  Colors.deepOrange: 'Deep orange',
  Colors.brown: 'Brown',
  Colors.blueGrey: 'Blue grey',
  Colors.grey: 'Grey',
  Colors.black: 'Black',
  Colors.white: 'White',
};
