import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_presentation/theme/themes.dart';
import 'package:flutter_presentation/widgets/bullet_list.dart';

class P2S05RunInference extends FlutterDeckSlideWidget {
  const P2S05RunInference()
      : super(
          configuration: const FlutterDeckSlideConfiguration(
            route: '/205',
          ),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.split(
      theme: Themes.lightTheme,
      leftBuilder: (context) => const BulletList(
        lightTheme: true,
        title: 'Class()',
        items: [
          'Creates a class',
          'Specify fields, methods, constructors',
        ],
      ),
      rightBuilder: (context) => Theme(
        data: ThemeData.light(),
        child: const FlutterDeckCodeHighlight(
          fileName: 'class.dart',
          code: """Class(
  (b) => b
    ..name = 'RouteNames'
    ..fields.addAll(
      routesMap.entries.map(
        (entry) {
          return Field(
            ...
          );
        },
      ),
    ),
);""",
        ),
      ),
    );
  }
}
