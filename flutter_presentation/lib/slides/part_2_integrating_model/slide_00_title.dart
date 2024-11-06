import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_presentation/theme/themes.dart';

class P2S00Title extends FlutterDeckSlideWidget {
  const P2S00Title()
      : super(
          configuration: const FlutterDeckSlideConfiguration(
            route: '/200',
          ),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.bigFact(
      title: 'Integrating a Machine Learning Model',
      theme: Themes.lightTheme,
    );
  }
}
