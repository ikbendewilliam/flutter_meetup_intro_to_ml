import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_presentation/theme/themes.dart';
import 'package:flutter_presentation/widgets/bullet_list.dart';

class LastSlide extends FlutterDeckSlideWidget {
  const LastSlide()
      : super(
          configuration: const FlutterDeckSlideConfiguration(
            route: '/last',
          ),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.split(
      theme: Themes.darkTheme,
      leftBuilder: (context) => const BulletList(
        title: 'Packages used/shown',
        height: 640,
        items: [
          'TensorFlow (+ Keras) (Python)',
          'NumPy (Python)',
          'Matplotlib (Python)',
          'Pillow (Python)',
          'Opencv (Python)',
          'Venv (Python)',
          'Jupyter (VS Code plugin)',
          'camera',
          'image',
          'tflite_flutter',
          'flutter_deck (used for presentation)',
        ],
      ),
      rightBuilder: (context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Some links:',
              style: TextStyle(
                fontSize: 32,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                const Spacer(),
                const Text(
                  'LinkedIn',
                  style: TextStyle(
                    fontSize: 32,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 32),
                Image.asset(
                  'assets/images/linkedin.png',
                  height: 200,
                  width: 200,
                  fit: BoxFit.contain,
                ),
              ],
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Image.asset(
                  'assets/images/presentation.png',
                  height: 200,
                  width: 200,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 32),
                const Text(
                  'This presentation (incl demos)',
                  style: TextStyle(
                    fontSize: 32,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 32),
            const BulletList(
              height: 300,
              title: 'Next steps if you\'re interested',
              items: [
                'Coursera Machine Learning (Stanford - Andrew Ng)',
                'Kaggle (Datasets)',
                'Forums, MOOCS, YouTube, …',
                'ChatGPT',
              ],
            ),
          ],
        ),
      ),
    );
  }
}
