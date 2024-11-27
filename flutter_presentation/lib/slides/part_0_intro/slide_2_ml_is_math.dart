import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_presentation/theme/themes.dart';

class P0S02MLIsMath extends FlutterDeckSlideWidget {
  const P0S02MLIsMath()
      : super(
          configuration: const FlutterDeckSlideConfiguration(
            route: '/002',
          ),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.split(
      theme: Themes.lightTheme,
      leftBuilder: (context) => const Center(
        child: Text(
          'Machine Learning is Math',
          style: TextStyle(
            fontSize: 48,
            color: Themes.lightThemeTitleColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      rightBuilder: (context) => Image.asset(
        'assets/images/mathmachinelearning.jpg',
      ),
    );
  }
}
