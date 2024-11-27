import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_presentation/theme/themes.dart';
import 'package:flutter_presentation/widgets/bullet_list.dart';

class P1S05TrainModel extends FlutterDeckSlideWidget {
  const P1S05TrainModel()
      : super(
          configuration: const FlutterDeckSlideConfiguration(
            route: '/105',
          ),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.split(
      theme: Themes.darkTheme,
      backgroundBuilder: Themes.darkThemeBackgroundBuilder,
      leftBuilder: (context) => const Center(
        child: BulletList(
          title: 'Step 3. Train the model',
          items: [
            'batch_size = 16 # How many samples we use for each training step',
            'learning_rate = 0.1 # How fast we learn',
            'epochs = 10 # How many times we go through the training data',
          ],
        ),
      ),
      rightBuilder: (context) => Theme(
        data: ThemeData.dark(),
        child: const FlutterDeckCodeHighlight(
          fileName: 'color_recognizer.py',
          code: '''
model_history = model.fit(train_batches, epochs=epochs,
                          steps_per_epoch=steps_per_epoch,
                          validation_steps=validation_steps,
                          validation_data=test_batches,
                          callbacks=[DisplayCallback()])
            ''',
        ),
      ),
    );
  }
}
