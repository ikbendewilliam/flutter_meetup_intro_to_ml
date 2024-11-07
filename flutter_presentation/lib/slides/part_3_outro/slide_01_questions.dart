import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_presentation/theme/themes.dart';

class P3S01Questions extends FlutterDeckSlideWidget {
  const P3S01Questions()
      : super(
          configuration: const FlutterDeckSlideConfiguration(
            route: '/401',
          ),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.bigFact(
      title: 'Questions',
      theme: Themes.lightTheme,
    );
  }
}
