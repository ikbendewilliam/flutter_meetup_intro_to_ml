import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_presentation/theme/themes.dart';
import 'package:flutter_presentation/widgets/bullet_list.dart';

class P2S02Libraries extends FlutterDeckSlideWidget {
  const P2S02Libraries()
      : super(
          configuration: const FlutterDeckSlideConfiguration(
            route: '/202',
          ),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.split(
      leftBuilder: (context) => const BulletList(
        lightTheme: true,
        title: 'Library: tflite_flutter',
        items: [
          'Version is important! 0.10.4 == tf 2.15',
          'Web is not supported',
          'Desktop requires building libraries (or downloading them)',
          'tflite_flutter_helper (deprecated)',
        ],
      ),
      rightBuilder: (context) => Theme(
        data: ThemeData.light(),
        child: const FlutterDeckCodeHighlight(
          fileName: 'pubspec.yaml',
          code: """
tflite_flutter: ^0.10.4
""",
        ),
      ),
      theme: Themes.lightTheme,
    );
  }
}
