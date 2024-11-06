import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_presentation/theme/themes.dart';
import 'package:flutter_presentation/widgets/bullet_list.dart';

class P0S04TypesOfSupervised extends FlutterDeckSlideWidget {
  const P0S04TypesOfSupervised()
      : super(
          configuration: const FlutterDeckSlideConfiguration(
            route: '/004',
          ),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.blank(
      theme: Themes.lightTheme,
      builder: (context) => const Center(
        child: BulletList(
          lightTheme: true,
          title: 'Some types of Supervised learning',
          items: [
            'Classification',
            'Object detection',
            'Segmentation',
            '...',
          ],
        ),
      ),
    );
  }
}
