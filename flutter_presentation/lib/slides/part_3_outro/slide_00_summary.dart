import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_presentation/theme/themes.dart';
import 'package:flutter_presentation/widgets/bullet_list.dart';

class P3S00Summary extends FlutterDeckSlideWidget {
  const P3S00Summary()
      : super(
          configuration: const FlutterDeckSlideConfiguration(
            route: '/400',
          ),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.split(
      theme: Themes.darkTheme,
      leftBuilder: (context) => const Center(
        child: BulletList(
          title: 'Develop',
          items: [
            '0.   Installing Required Libraries',
            '1.   Load and validate dataset',
            '2.   Create and compile model',
            '3.   Train the model',
            '4.   Evaluate history',
            '5.   Manually evaluate model',
            '6.   Save model',
          ],
        ),
      ),
      rightBuilder: (context) => const Center(
        child: BulletList(
          lightTheme: true,
          title: 'Integrate',
          items: [
            '7.   Installing Required Libraries (tflite_flutter)',
            '8.   Load model',
            '9.   Preprocess input',
            '10.  Run inference',
            '11.  Handle output',
          ],
        ),
      ),
    );
  }
}
