import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_presentation/slides/part_0_intro/_part_0_exports.dart';
import 'package:flutter_presentation/slides/part_1_develop_ml_model/_part_1_exports.dart';
import 'package:flutter_presentation/slides/part_2_integrating_model/_part_2_exports.dart';
import 'package:flutter_presentation/slides/part_3_outro/_part_3_exports.dart';
import 'package:flutter_presentation/theme/themes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterDeckApp(
      configuration: const FlutterDeckConfiguration(
        transition: FlutterDeckTransition.slide(),
        controls: FlutterDeckControlsConfiguration(
          presenterToolbarVisible: false,
        ),
        footer: FlutterDeckFooterConfiguration(
          showSlideNumbers: true,
          showSocialHandle: true,
        ),
        header: FlutterDeckHeaderConfiguration(
          showHeader: false,
        ),
        showProgress: false,
      ),
      slides: [
        ...slidesPart0,
        ...slidesPart1,
        ...slidesPart2,
        ...slidesPart3,
      ],
      lightTheme: Themes.lightTheme,
      darkTheme: Themes.darkTheme,
      themeMode: ThemeMode.light,
      speakerInfo: const FlutterDeckSpeakerInfo(
        name: 'William Verhaeghe',
        description: 'Flutter lead and AI Domain lead at icapps',
        socialHandle: '',
        imagePath: 'assets/images/me.png',
      ),
    );
  }
}
