import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_presentation/theme/themes.dart';

class P1S04bModelVisualised extends FlutterDeckSlideWidget {
  const P1S04bModelVisualised()
      : super(
          configuration: const FlutterDeckSlideConfiguration(
            route: '/104b',
          ),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.image(
      theme: Themes.lightTheme,
      imageBuilder: (context) => Image.asset(
        'assets/images/model_overview.png',
        fit: BoxFit.contain,
      ),
    );
  }
}
