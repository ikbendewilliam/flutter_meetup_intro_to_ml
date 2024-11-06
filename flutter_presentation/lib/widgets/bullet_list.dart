import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_presentation/theme/themes.dart';

class BulletList extends StatelessWidget {
  final String? title;
  final List<String> items;
  final bool lightTheme;
  final double? height;

  const BulletList({
    this.title,
    required this.items,
    this.lightTheme = false,
    this.height,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: TextStyle(
                fontSize: 48,
                color: lightTheme ? Themes.lightThemeTitleColor : Themes.darkThemeTitleColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),
          ],
          SizedBox(
            width: 600,
            height: height ?? 400,
            child: FlutterDeckBulletListTheme(
              data: lightTheme ? Themes.lightThemeFlutterDeckBulletListThemeData : Themes.darkThemeFlutterDeckBulletListThemeData,
              child: FlutterDeckBulletList(
                items: items,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
