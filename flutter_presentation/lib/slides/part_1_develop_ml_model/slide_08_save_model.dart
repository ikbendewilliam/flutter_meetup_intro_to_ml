import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_presentation/theme/themes.dart';
import 'package:flutter_presentation/widgets/bullet_list.dart';

class P1S08SaveModel extends FlutterDeckSlideWidget {
  const P1S08SaveModel()
      : super(
          configuration: const FlutterDeckSlideConfiguration(
            route: '/108',
          ),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.split(
      theme: Themes.darkTheme,
      backgroundBuilder: Themes.darkThemeBackgroundBuilder,
      leftBuilder: (context) => const Center(
        child: BulletList(
          title: 'Step 6. Save the model',
          items: [
            '.keras .h5',
            '.tflite',
          ],
        ),
      ),
      rightBuilder: (context) => Theme(
        data: ThemeData.dark(),
        child: const FlutterDeckCodeHighlight(
          fileName: 'color_recognizer.py',
          code: '''
model.save(f'models/{model_version}.keras')

converter = tf.lite.TFLiteConverter.from_keras_model(model)
tflite_model = converter.convert()
with tf.io.gfile.GFile(f'models/{model_version}.tflite', 'wb') as f:
  f.write(tflite_model)
              ''',
        ),
      ),
    );
  }
}
