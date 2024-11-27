import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_presentation/theme/themes.dart';
import 'package:flutter_presentation/widgets/bullet_list.dart';

class P1S06EvaluateHistory extends FlutterDeckSlideWidget {
  const P1S06EvaluateHistory()
      : super(
          configuration: const FlutterDeckSlideConfiguration(
            route: '/106',
          ),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.split(
      theme: Themes.darkTheme,
      backgroundBuilder: Themes.darkThemeBackgroundBuilder,
      leftBuilder: (context) => const Center(
        child: BulletList(
          title: 'Step 4. Evaluate history',
          items: [
            'Metrics: Accuracy, Loss, Precision, Recall',
            'Check for Overfitting',
            'Adjust hyperparameters',
          ],
        ),
      ),
      rightBuilder: (context) => Column(
        children: [
          Expanded(child: Image.asset('assets/images/history.png')),
          Expanded(child: Image.asset('assets/images/history_overfitting.png')),
        ],
      ),
    );
  }
}
