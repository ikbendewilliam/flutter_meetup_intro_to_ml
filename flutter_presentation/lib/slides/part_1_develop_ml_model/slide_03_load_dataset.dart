import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_presentation/theme/themes.dart';
import 'package:flutter_presentation/widgets/bullet_list.dart';

class P1S03LoadDataset extends FlutterDeckSlideWidget {
  const P1S03LoadDataset()
      : super(
          configuration: const FlutterDeckSlideConfiguration(
            route: '/103',
          ),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.split(
      theme: Themes.darkTheme,
      backgroundBuilder: Themes.darkThemeBackgroundBuilder,
      leftBuilder: (context) => const Center(
        child: BulletList(
          title: 'Step 1. Load Dataset',
          items: [
            'Sources of Datasets (e.g., Kaggle, Custom)',
            'Load images/text/labels/...',
            'Preprocess input (resize, normalize, augment)',
            'Preprocess output (one-hot encode, resize)',
            'Split data (train/validate/test)',
          ],
        ),
      ),
      rightBuilder: (context) => Theme(
        data: ThemeData.dark(),
        child: const FlutterDeckCodeHighlight(
          fileName: 'example.csv',
          code: '''
            r,g,b,label
            255,0,0,0 # red
            251,0,0,0
            252,3,4,0
            0,255,0,1 # green
            2,251,13,1
            ...
            ''',
        ),
      ),
    );
  }
}
