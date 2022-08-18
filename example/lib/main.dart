import 'package:example/home_page.dart';
import 'package:flutter/material.dart';
import 'package:impression/impression.dart';

void main() {
  DefaultImpressionDetectorConfig.resetWhen
      .add(ImpressionDetectorReset.leftScreen);
  DefaultImpressionDetectorConfig.durationThreshold =
      const Duration(seconds: 1);
  DefaultImpressionDetectorConfig.visibleFractionThreshold = 0.5;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}
