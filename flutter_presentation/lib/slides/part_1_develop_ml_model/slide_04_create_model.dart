import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_presentation/theme/themes.dart';

class P1S04CreateModel extends FlutterDeckSlideWidget {
  const P1S04CreateModel()
      : super(
          configuration: const FlutterDeckSlideConfiguration(
            route: '/104',
          ),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.split(
      theme: Themes.darkTheme,
      backgroundBuilder: Themes.darkThemeBackgroundBuilder,
      splitRatio: const SplitSlideRatio(right: 2),
      leftBuilder: (context) => const Center(
        child: Text(
          'Step 2. Define the model',
          style: TextStyle(
            fontSize: 48,
            color: Themes.darkThemeTitleColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      rightBuilder: (context) => Theme(
        data: ThemeData.dark(),
        child: const FlutterDeckCodeHighlight(
          fileName: 'color_recognizer.py',
          code: '''
input_layer = layers.Input(shape=input_shape)
output_layer = layers.Dense(num_outputs, activation='softmax')(input_layer)
model = models.Model(inputs=input_layer, outputs=[output_layer])
            ''',
        ),
      ),
    );
  }
}
