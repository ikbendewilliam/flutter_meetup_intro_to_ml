import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_presentation/theme/themes.dart';

class P2S03LoadModel extends FlutterDeckSlideWidget {
  const P2S03LoadModel()
      : super(
          configuration: const FlutterDeckSlideConfiguration(
            route: '/203',
          ),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.bigFact(
      theme: Themes.lightTheme,
      title: 'package example: json_serializable',
    );
  }
}
