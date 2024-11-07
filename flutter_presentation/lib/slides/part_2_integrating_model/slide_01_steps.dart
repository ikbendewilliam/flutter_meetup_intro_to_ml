import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_presentation/theme/themes.dart';
import 'package:flutter_presentation/widgets/bullet_list.dart';

class P2S01Steps extends FlutterDeckSlideWidget {
  const P2S01Steps()
      : super(
          configuration: const FlutterDeckSlideConfiguration(
            route: '/201',
          ),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.blank(
      theme: Themes.lightTheme,
      builder: (context) => const BulletList(
        lightTheme: true,
        title: 'Steps to integrate a model',
        items: [
          '7.   Installing Required Libraries (tflite_flutter)',
          '8.   Load model',
          '9.   Preprocess input',
          '10.  Run inference',
          '11.  Handle output',
        ],
      ),
    );
  }
}
