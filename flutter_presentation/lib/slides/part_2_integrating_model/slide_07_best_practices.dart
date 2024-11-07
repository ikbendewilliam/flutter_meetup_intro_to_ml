import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_presentation/theme/themes.dart';
import 'package:flutter_presentation/widgets/bullet_list.dart';

class P2S07BestPractices extends FlutterDeckSlideWidget {
  const P2S07BestPractices()
      : super(
          configuration: const FlutterDeckSlideConfiguration(
            route: '/207',
          ),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.blank(
      theme: Themes.lightTheme,
      builder: (context) => const BulletList(
        lightTheme: true,
        title: 'Best practices for Machine Learning in Mobile Apps',
        items: [
          'Keeping Models Lightweight',
          'User Privacy & On-Device Inference',
          'Real-time vs Batch Inference',
          'Security?',
          'Use existing models/plugins',
          'Not everything should use Machine Learning!',
        ],
      ),
    );
  }
}
