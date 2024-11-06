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
      theme: Themes.lightTheme,
      leftBuilder: (context) => const BulletList(
        lightTheme: true,
        title: 'Packages used/shown',
        items: [
          'flutter_shader_snap',
          'GitHub copilot',
          'model_generator',
          'icapps/flutter-template',
          'fgen',
          'json_serializable',
          'build_runner (dart/build)',
          'code_builder',
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
                Image.asset(
                  'assets/images/pub_dev_snap.png',
                  height: 200,
                  width: 200,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 32),
                const Text(
                  'flutter_shader_snap',
                  style: TextStyle(
                    fontSize: 32,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
              ],
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
          ],
        ),
      ),
    );
  }
}
