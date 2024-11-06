import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_presentation/theme/themes.dart';
import 'package:flutter_shader_snap/flutter_shader_snap.dart';

class P0S00Title extends FlutterDeckSlideWidget {
  const P0S00Title()
      : super(
          configuration: const FlutterDeckSlideConfiguration(
            route: '/000',
            footer: FlutterDeckFooterConfiguration(showFooter: false),
          ),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.title(
      title: 'Intro to Machine Learning',
      subtitle: 'How to develop a machine learning model and integrate it in a Flutter app',
      theme: Themes.lightTheme,
      backgroundBuilder: (context) => Align(
        alignment: const Alignment(0, 0.8),
        child: _TitleBackground(),
      ),
    );
  }
}

class _TitleBackground extends StatefulWidget {
  @override
  State<_TitleBackground> createState() => _TitleBackgroundState();
}

class _TitleBackgroundState extends State<_TitleBackground> with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 5),
    value: 1,
  )..reverse();

  var _reversed = true;

  @override
  void initState() {
    super.initState();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _reversed = true;
        });
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        setState(() {
          _reversed = false;
        });
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SnapShader(
      controller: _controller,
      snapShaderType: _reversed ? SnapShaderType.splitReversed : SnapShaderType.split,
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'Welcome',
          style: TextStyle(
            fontSize: 100,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
