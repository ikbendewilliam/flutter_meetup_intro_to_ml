import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_presentation/theme/themes.dart';
import 'package:flutter_presentation/widgets/bullet_list.dart';

class P2S05RunInference extends FlutterDeckSlideWidget {
  const P2S05RunInference()
      : super(
          configuration: const FlutterDeckSlideConfiguration(
            route: '/205',
          ),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.split(
      leftBuilder: (context) => const BulletList(
        lightTheme: true,
        title: 'Run on model',
        items: [
          'Prepare output buffer',
          'Run inference',
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
""",
        ),
      ),
      theme: Themes.lightTheme,
    );
  }
}
