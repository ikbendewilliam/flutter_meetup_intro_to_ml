import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_presentation/theme/themes.dart';
import 'package:flutter_presentation/widgets/bullet_list.dart';

class P0S02cTypesOfML extends FlutterDeckSlideWidget {
  const P0S02cTypesOfML()
      : super(
          configuration: const FlutterDeckSlideConfiguration(
            route: '/002c',
          ),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.blank(
      theme: Themes.lightTheme,
      builder: (context) => const Center(
        child: BulletList(
          lightTheme: true,
          title: 'Types of Machine learning',
          items: [
            'Supervised Learning',
            'Unsupervised Learning',
            'Reinforcement Learning',
          ],
        ),
      ),
    );
  }
}
