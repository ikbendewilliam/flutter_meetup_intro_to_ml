import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_presentation/theme/themes.dart';
import 'package:flutter_presentation/widgets/bullet_list.dart';

class P1S01Steps extends FlutterDeckSlideWidget {
  const P1S01Steps()
      : super(
          configuration: const FlutterDeckSlideConfiguration(
            route: '/101',
          ),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.blank(
      theme: Themes.darkTheme,
      backgroundBuilder: Themes.darkThemeBackgroundBuilder,
      builder: (context) => const BulletList(
        title: 'Steps to train a model',
        items: [
          '0.   Installing Required Libraries',
          '1.   Load and validate dataset',
          '2.   Create and compile model',
          '3.   Train the model',
          '4.   Evaluate history',
          '5.   Manually evaluate model',
          '6.   Save model',
        ],
      ),
    );
  }
}
