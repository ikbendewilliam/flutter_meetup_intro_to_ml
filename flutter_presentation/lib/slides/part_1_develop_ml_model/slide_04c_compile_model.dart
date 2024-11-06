import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_presentation/theme/themes.dart';
import 'package:flutter_presentation/widgets/bullet_list.dart';

class P1S04cCompileModel extends FlutterDeckSlideWidget {
  const P1S04cCompileModel()
      : super(
          configuration: const FlutterDeckSlideConfiguration(
            route: '/104c',
          ),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.split(
      theme: Themes.darkTheme,
      backgroundBuilder: Themes.darkThemeBackgroundBuilder,
      leftBuilder: (context) => const Center(
        child: BulletList(
          title: 'Compile Model',
          items: [
            'Choose a loss function',
            'Choose an optimizer',
            'Choose metrics to monitor',
          ],
        ),
      ),
      rightBuilder: (context) => Theme(
        data: ThemeData.dark(),
        child: const FlutterDeckCodeHighlight(
          fileName: 'color_recognizer.py',
          code: '''
model = create_classification_model()
optimizer = Adam(learning_rate=learning_rate)
model.compile(optimizer=optimizer,
              loss=CategoricalCrossentropy(),
              metrics='mse')
            ''',
        ),
      ),
    );
  }
}
