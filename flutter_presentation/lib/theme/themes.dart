import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';

class Themes {
  static const Color lightThemeTitleColor = Color(0xFF012547);

  static const Color darkThemeTitleColor = Colors.white;

  static FlutterDeckThemeData lightTheme = FlutterDeckThemeData.fromThemeAndText(
    ThemeData.from(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF012547),
        background: Colors.white,
      ),
      useMaterial3: true,
    ),
    const FlutterDeckTextTheme().apply(
      color: const Color(0xFF012547),
    ),
  );

  static FlutterDeckThemeData darkTheme = FlutterDeckThemeData.fromThemeAndText(
    ThemeData.from(
      colorScheme: ColorScheme.fromSeed(
        background: const Color(0xFF012547),
        seedColor: const Color(0xFF012547),
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
    ),
    const FlutterDeckTextTheme().apply(
      color: Colors.white,
    ),
  );

  static Widget Function(BuildContext) darkThemeBackgroundBuilder = (context) => Container(
        color: const Color(0xFF012547),
      );

  static const FlutterDeckBulletListThemeData darkThemeFlutterDeckBulletListThemeData = FlutterDeckBulletListThemeData(
    color: Colors.white,
    textStyle: TextStyle(
      fontSize: 1000,
    ),
  );
  static const FlutterDeckBulletListThemeData lightThemeFlutterDeckBulletListThemeData = FlutterDeckBulletListThemeData(
    color: Color(0xFF012547),
    textStyle: TextStyle(
      fontSize: 1000,
    ),
  );

  static const FlutterDeckCodeHighlightThemeData darkThemeCodeHighlightThemeData = FlutterDeckCodeHighlightThemeData(
    backgroundColor: Colors.blue,
    textStyle: TextStyle(color: Colors.white),
  );
}
