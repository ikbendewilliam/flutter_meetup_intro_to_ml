import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_presentation/theme/themes.dart';

class P1S02bLibraries extends FlutterDeckSlideWidget {
  const P1S02bLibraries()
      : super(
          configuration: const FlutterDeckSlideConfiguration(
            route: '/102b',
          ),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.blank(
      theme: Themes.darkTheme,
      backgroundBuilder: Themes.darkThemeBackgroundBuilder,
      builder: (context) => Theme(
        data: ThemeData.dark(),
        child: const Center(
          child: FlutterDeckCodeHighlight(
            fileName: 'color_recognizer.py',
            code: '''
          import tensorflow as tf
          from tensorflow.keras import layers, models
          from tensorflow.keras.losses import CategoricalCrossentropy
          from tensorflow.keras.optimizers import Adam
          from IPython.display import clear_output
          import matplotlib.pyplot as plt
          import random
          ''',
          ),
        ),
      ),
    );
  }
}
