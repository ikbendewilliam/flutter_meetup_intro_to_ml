import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_presentation/theme/themes.dart';

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
      leftBuilder: (context) => Theme(
        data: ThemeData.light(),
        child: const FlutterDeckCodeHighlight(
          fileName: 'library_generator.dart',
          code: '''class LibraryGenerator {
  Library generate() {
    return Library(
      (b) => b
        ..body.addAll(
          [
            Class(
              (b) => b
                ..name = className
                ..methods.add(
                  Method(
                    (b) => b
                      ..name = 'printHelloWorld'
                      ..lambda = true
                      ..body = const Code("print('hello world')"),
                  ),
                ),
            ),
          ],
        ),
      );
  }
}''',
        ),
      ),
      rightBuilder: (context) => Theme(
        data: ThemeData.light(),
        child: const FlutterDeckCodeHighlight(
          fileName: 'result.dart',
          code: """class Example {
  static printHelloWorld() => print('hello world');
}
""",
        ),
      ),
      theme: Themes.lightTheme,
    );
  }
}
