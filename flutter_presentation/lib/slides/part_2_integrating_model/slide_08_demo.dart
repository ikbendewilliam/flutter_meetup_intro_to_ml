import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_presentation/theme/themes.dart';

class P2S08Demo extends FlutterDeckSlideWidget {
  const P2S08Demo()
      : super(
          configuration: const FlutterDeckSlideConfiguration(
            route: '/208',
          ),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.bigFact(
      theme: Themes.lightTheme,
      title: 'DEMO',
    );
  }
}
