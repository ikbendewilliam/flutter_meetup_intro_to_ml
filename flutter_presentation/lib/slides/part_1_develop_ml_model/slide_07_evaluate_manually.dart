import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_presentation/theme/themes.dart';
import 'package:flutter_presentation/widgets/color_demo.dart';

class P1S07EvaluateManually extends FlutterDeckSlideWidget {
  const P1S07EvaluateManually()
      : super(
          configuration: const FlutterDeckSlideConfiguration(
            route: '/107',
          ),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.blank(
      theme: Themes.darkTheme,
      backgroundBuilder: Themes.darkThemeBackgroundBuilder,
      builder: (context) => const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Evaluate manually',
            style: TextStyle(
              fontSize: 48,
              color: Themes.darkThemeTitleColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 32),
          Expanded(
            child: ColorRecognizerDemo(),
          ),
        ],
      ),
    );
  }
}
