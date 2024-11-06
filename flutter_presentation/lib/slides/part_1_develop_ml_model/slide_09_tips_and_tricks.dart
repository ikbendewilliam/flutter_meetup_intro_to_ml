import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_presentation/theme/themes.dart';
import 'package:flutter_presentation/widgets/bullet_list.dart';

class P1S09TipsAndTricks extends FlutterDeckSlideWidget {
  const P1S09TipsAndTricks()
      : super(
          configuration: const FlutterDeckSlideConfiguration(
            route: '/109',
          ),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.blank(
      theme: Themes.darkTheme,
      backgroundBuilder: Themes.darkThemeBackgroundBuilder,
      builder: (context) => const Center(
        child: BulletList(
          title: 'Tips and tricks',
          items: [
            'Quality of data',
            'Data relevance',
            'Validate after each step',
            'Versions are important (use venv)',
          ],
        ),
      ),
    );
  }
}
