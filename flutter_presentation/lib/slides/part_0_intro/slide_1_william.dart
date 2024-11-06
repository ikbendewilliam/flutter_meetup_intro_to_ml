import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_presentation/theme/themes.dart';
import 'package:flutter_presentation/widgets/bullet_list.dart';
import 'package:flutter_shader_snap/flutter_shader_snap.dart';

class P0S01William extends FlutterDeckSlideWidget {
  const P0S01William()
      : super(
          configuration: const FlutterDeckSlideConfiguration(
            route: '/001',
            steps: 2,
          ),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.blank(
      theme: Themes.lightTheme,
      builder: (context) => const P0S01WilliamContent(),
    );
  }
}

class P0S01WilliamContent extends StatelessWidget {
  const P0S01WilliamContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(
            child: BulletList(
              height: 300,
              lightTheme: true,
              items: [
                'Flutter Lead & AI Domain lead at icapps',
                'Apps like CovidSafeBE, Ampere, Sibos, Blue-bike, ...',
                'Passion for efficiency and animations',
              ],
            ),
          ),
          const Spacer(),
          FlutterDeckSlideStepsBuilder(
            builder: (context, stepNumber) => stepNumber == 1
                ? const Opacity(
                    opacity: 0,
                    child: ShaderExample(),
                  )
                : const ShaderExample(),
          ),
        ],
      ),
    );
  }
}

class ShaderExample extends StatefulWidget {
  const ShaderExample({super.key});

  @override
  State<ShaderExample> createState() => ShaderExampleState();
}

class ShaderExampleState extends State<ShaderExample> with SingleTickerProviderStateMixin {
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
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/me.png',
              width: 400,
            ),
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) => ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (bounds) => LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white,
                    Color.lerp(Colors.blue, Colors.purple, _controller.value)!,
                    Color.lerp(Colors.blue[900], Colors.purple[900], _controller.value)!,
                  ],
                  stops: const [0.0, 0.7, 1],
                ).createShader(
                  Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                ),
                child: child,
              ),
              child: const Text(
                'I like shaders',
                style: TextStyle(
                  fontSize: 100,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
