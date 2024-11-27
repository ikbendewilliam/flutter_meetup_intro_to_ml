import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_presentation/theme/themes.dart';
import 'package:flutter_presentation/widgets/bullet_list.dart';

class P2S04PreprocessInput extends FlutterDeckSlideWidget {
  const P2S04PreprocessInput()
      : super(
          configuration: const FlutterDeckSlideConfiguration(
            route: '/204',
          ),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.split(
      leftBuilder: (context) => const BulletList(
        lightTheme: true,
        title: 'Step 9. Preprocess data',
        items: [
          'Same preprocessing as done on training data',
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
""",
        ),
      ),
      theme: Themes.lightTheme,
    );
  }
}
