import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_presentation/theme/themes.dart';
import 'package:flutter_presentation/widgets/bullet_list.dart';

class P2S04PreprocessInput extends FlutterDeckSlideWidget {
  const P2S04PreprocessInput()
      : super(
          configuration: const FlutterDeckSlideConfiguration(
            route: '/204',
          ),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.split(
      theme: Themes.lightTheme,
      leftBuilder: (context) => const BulletList(
        lightTheme: true,
        title: '@annotations',
        items: [
          'Find where to generate code',
          'Receive details about classes/code',
        ],
      ),
      rightBuilder: (context) => Theme(
        data: ThemeData.light(),
        child: const FlutterDeckCodeHighlight(
          fileName: 'result.dart',
          code: """const TypeChecker _flutterRouteAnnotationChecker = TypeChecker.fromRuntime(FlutterRoute);
...
  List<RouteConfig> resolve(ClassElement classElement) {
    final flutterRouteAnnotations = _flutterRouteAnnotationChecker.annotationsOf(classElement, throwOnUnresolved: false);
    ...
  }
...
  RouteConfig _resolveRoute(ClassElement classElement, DartObject flutterRouteAnnotation) {
    final flutterRoute = ConstantReader(flutterRouteAnnotation);

    final routeNameValue = flutterRoute.peek('routeName')?.stringValue;
    final routeName = routeNameValue ?? CaseUtil(classElement.name).kebabCase;
    final returnType = flutterRoute.peek('returnType')?.typeValue;
...
""",
        ),
      ),
    );
  }
}
