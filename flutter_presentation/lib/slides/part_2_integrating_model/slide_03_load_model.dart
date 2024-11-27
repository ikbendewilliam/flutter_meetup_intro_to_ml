import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_presentation/theme/themes.dart';
import 'package:flutter_presentation/widgets/bullet_list.dart';

class P2S03LoadModel extends FlutterDeckSlideWidget {
  const P2S03LoadModel()
      : super(
          configuration: const FlutterDeckSlideConfiguration(
            route: '/203',
          ),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.split(
      leftBuilder: (context) => const BulletList(
        lightTheme: true,
        title: 'Step 8. Load model',
        items: [
          '.tflite file',
          '"Interpreter"',
        ],
      ),
      rightBuilder: (context) => Theme(
        data: ThemeData.light(),
        child: const FlutterDeckCodeHighlight(
          fileName: 'color_demo.dart',
          code: """
_interpreter = await Interpreter.fromAsset('assets/models/color_recognizer.tflite');
""",
        ),
      ),
      theme: Themes.lightTheme,
    );
  }
}
