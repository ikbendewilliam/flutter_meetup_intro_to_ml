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
    return FlutterDeckSlide.split(
      theme: Themes.lightTheme,
      leftBuilder: (context) => const BulletList(
        lightTheme: true,
        title: 'Field()',
        items: [
          'Creates a field',
          'Specify name, type, annotations and body',
        ],
      ),
      rightBuilder: (context) => Theme(
        data: ThemeData.light(),
        child: const FlutterDeckCodeHighlight(
          fileName: 'class.dart',
          code: """Field(
  (b) => b
    ..name = CaseUtil(entry.key).camelCase
    ..static = true
    ..modifier = FieldModifier.constant
    ..assignment = Code(
        "'\${entry.key.startsWith('/') ? '' : '/'}\${entry.value ? entry.key : CaseUtil(entry.key, removeSuffixes: removeSuffixes).textWithoutSuffix}'"),
)
""",
        ),
      ),
    );
  }
}
