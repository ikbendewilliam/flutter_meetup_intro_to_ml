import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_presentation/theme/themes.dart';

class P1S04eVerifyModelResult extends FlutterDeckSlideWidget {
  const P1S04eVerifyModelResult()
      : super(
          configuration: const FlutterDeckSlideConfiguration(
            route: '/104e',
          ),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.image(
      theme: Themes.darkTheme,
      backgroundBuilder: Themes.darkThemeBackgroundBuilder,
      imageBuilder: (context) => const Image(
        image: AssetImage('assets/images/initial_output.png'),
        fit: BoxFit.contain,
      ),
    );
  }
}
