import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_presentation/theme/themes.dart';
import 'package:flutter_presentation/widgets/video_player.dart';

class P1S05bTrainModelVideo extends FlutterDeckSlideWidget {
  const P1S05bTrainModelVideo()
      : super(
          configuration: const FlutterDeckSlideConfiguration(
            route: '/105b',
          ),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.blank(
      theme: Themes.darkTheme,
      backgroundBuilder: Themes.darkThemeBackgroundBuilder,
      builder: (context) => const Center(
        child: PresentationVideoPlayer(
          asset: 'assets/videos/train_model.mp4',
        ),
      ),
    );
  }
}
