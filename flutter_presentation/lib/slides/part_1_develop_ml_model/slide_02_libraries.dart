import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_presentation/theme/themes.dart';
import 'package:flutter_presentation/widgets/bullet_list.dart';

class P1S02Libraries extends FlutterDeckSlideWidget {
  const P1S02Libraries()
      : super(
          configuration: const FlutterDeckSlideConfiguration(
            route: '/102',
          ),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.blank(
      theme: Themes.darkTheme,
      backgroundBuilder: Themes.darkThemeBackgroundBuilder,
      builder: (context) => const BulletList(
        title: 'Step 0. install required libraries',
        height: 600,
        items: [
          'TensorFlow (+ Keras) - Everything with models',
          'NumPy - Handle matrices',
          'Matplotlib - Visualise graphs and images',
          'Pillow - Load and show images',
          'Opencv - Process images',
          'Venv - Virtual environment to keep Python processing localised',
          'Jupyter (VS Code plugin) - Execute Python code easier',
        ],
      ),
    );
  }
}
