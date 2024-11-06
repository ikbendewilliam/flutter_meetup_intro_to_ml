import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_presentation/theme/themes.dart';
import 'package:flutter_presentation/widgets/bullet_list.dart';

class P1S04dVerifyModel extends FlutterDeckSlideWidget {
  const P1S04dVerifyModel()
      : super(
          configuration: const FlutterDeckSlideConfiguration(
            route: '/104d',
          ),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.split(
      theme: Themes.darkTheme,
      backgroundBuilder: Themes.darkThemeBackgroundBuilder,
      leftBuilder: (context) => const Center(
        child: BulletList(
          title: 'Run prediction on untrained Model',
          items: [
            'Running Sample Predictions Before Training',
            'Ensuring Model Outputs are Valid',
            'Verify prediction is visually "correct"',
          ],
        ),
      ),
      rightBuilder: (context) => Theme(
        data: ThemeData.dark(),
        child: const FlutterDeckCodeHighlight(
          fileName: 'color_recognizer.py',
          code: '''
for ipnut, color in dataset.take(2):
    predictions = model.predict(ipnut)  # Predict bounding boxes
    display(ipnut, color, predictions)  # Visualize ipnut with predicted color
            ''',
        ),
      ),
    );
  }
}
