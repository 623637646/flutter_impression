import 'package:example/home_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:impression/impression.dart';
import 'package:flutter_ume/flutter_ume.dart';
import 'package:flutter_ume_kit_perf/flutter_ume_kit_perf.dart';

void main() {
  DefaultImpressionDetectorConfig.resetWhen
      .add(ImpressionDetectorReset.leftScreen);
  DefaultImpressionDetectorConfig.durationThreshold =
      const Duration(seconds: 1);
  DefaultImpressionDetectorConfig.visibleFractionThreshold = 0.5;

  if (kDebugMode) {
    PluginManager.instance
      ..register(Performance())
      ..register(const MemoryInfoPage());
    runApp(const UMEWidget(enable: true, child: MyApp()));
  } else {
    runApp(const MyApp());
  }
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
