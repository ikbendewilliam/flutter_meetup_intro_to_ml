import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_presentation/theme/themes.dart';
import 'package:flutter_presentation/widgets/bullet_list.dart';

class P3S00Summary extends FlutterDeckSlideWidget {
  const P3S00Summary()
      : super(
          configuration: const FlutterDeckSlideConfiguration(
            route: '/400',
          ),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.blank(
      theme: Themes.lightTheme,
      builder: (context) => const Center(
        child: BulletList(
          lightTheme: true,
          title: 'Types of generation',
          items: [
            'Copilot',
            'File().write()',
            'build_runner',
            'build_runner multiple files',
          ],
        ),
      ),
    );
  }
}
