import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_presentation/theme/themes.dart';
import 'package:flutter_svg/svg.dart';

class P0S03NeuralNetwork extends FlutterDeckSlideWidget {
  const P0S03NeuralNetwork()
      : super(
          configuration: const FlutterDeckSlideConfiguration(
            route: '/003',
          ),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.blank(
      theme: Themes.lightTheme,
      builder: (context) => Container(
        alignment: Alignment.center,
        child: FittedBox(
          fit: BoxFit.contain,
          child: SvgPicture.asset(
            'assets/images/neural_network.svg',
          ),
        ),
      ),
    );
  }
}
