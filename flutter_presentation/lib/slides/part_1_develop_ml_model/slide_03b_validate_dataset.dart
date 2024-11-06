import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_presentation/theme/themes.dart';
import 'package:flutter_presentation/widgets/bullet_list.dart';

class P1S03bValidateDataset extends FlutterDeckSlideWidget {
  const P1S03bValidateDataset()
      : super(
          configuration: const FlutterDeckSlideConfiguration(
            route: '/103b',
          ),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.split(
      theme: Themes.darkTheme,
      backgroundBuilder: Themes.darkThemeBackgroundBuilder,
      leftBuilder: (context) => const Center(
        child: BulletList(
          title: 'Validate Dataset',
          items: [
            'Validate the data is loaded correctly',
            'Validate labels are correct',
            'Validate data is balanced',
          ],
        ),
      ),
      rightBuilder: (context) => Theme(
        data: ThemeData.dark(),
        child: Column(
          children: [
            const Spacer(),
            Image.asset(
              'assets/images/label_validation.png',
            ),
            const SizedBox(height: 8),
            const FlutterDeckCodeHighlight(
              code: '''
            Distribution of colors in training data:
            red: 1168 (1.33%)
            pink: 1559 (1.78%)
            purple: 6892 (7.88%)
            deepPurple: 3897 (4.45%)
            indigo: 5169 (5.91%)
            blue: 1012 (1.16%)
            ...              ''',
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
