import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_presentation/theme/themes.dart';

class P0S02bMLInvolvesMath extends FlutterDeckSlideWidget {
  const P0S02bMLInvolvesMath()
      : super(
          configuration: const FlutterDeckSlideConfiguration(
            route: '/002b',
          ),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.split(
      theme: Themes.lightTheme,
      leftBuilder: (context) => const Text(
        'Machine Learning involves quite a lot of Math',
        style: TextStyle(
          fontSize: 48,
          color: Themes.lightThemeTitleColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      rightBuilder: (context) => const FlutterDeckCodeHighlight(
        fileName: 'predict.dart',
        code: '''...
for (int i = 0; i < resizedBytes.length; i++) {
  normalizedBytes[i] = resizedBytes[i] / 255.0;
}
''',
      ),
    );
  }
}
