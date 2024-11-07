import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_presentation/theme/themes.dart';
import 'package:flutter_presentation/widgets/bullet_list.dart';

class P2S06HandleOutput extends FlutterDeckSlideWidget {
  const P2S06HandleOutput()
      : super(
          configuration: const FlutterDeckSlideConfiguration(
            route: '/206',
          ),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.split(
      leftBuilder: (context) => const BulletList(
        lightTheme: true,
        title: 'Handle output',
        items: [
          'Ouput is a list for each input, a single input means a list of one element',
          'Result can be a list of probabilities',
          'Map probabilities to labels',
        ],
      ),
      rightBuilder: (context) => Theme(
        data: ThemeData.light(),
        child: const FlutterDeckCodeHighlight(
          fileName: 'color_demo.dart',
          code: """
double red = 0;
double green = 0;
double blue = 0;
...
void predict() {
  final interpreter = _interpreter;
  if (interpreter == null) return;
  final input = [red / 255, green / 255, blue / 255];
  var output = List.filled(_interpreter!.getOutputTensor(0).shape[1], 0).reshape([1, 21]);
  _interpreter!.run(input, output);
  
  setState(() {
    for (var i = 0; i < output[0].length; i++) {
      colorsPredictions[colorsPredictions.keys.elementAt(i)] = output[0][i];
    }
  });
}
""",
        ),
      ),
      theme: Themes.lightTheme,
    );
  }
}
