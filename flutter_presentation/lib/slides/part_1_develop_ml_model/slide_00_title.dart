import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_presentation/theme/themes.dart';

class P1S00Title extends FlutterDeckSlideWidget {
  const P1S00Title()
      : super(
          configuration: const FlutterDeckSlideConfiguration(
            route: '/100',
          ),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.bigFact(
      title: 'Basics of developing a Machine Learning Model',
      theme: Themes.darkTheme,
      backgroundBuilder: Themes.darkThemeBackgroundBuilder,
    );
  }
}
