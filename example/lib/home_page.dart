import 'dart:math';
import 'package:example/demo_list_view.dart';
import 'package:example/demo_single_child_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:impression/impression.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Impression Detector Demo"),
      ),
      body: ListView(
        children: ListTile.divideTiles(
          context: context,
          tiles: [
            _headerWidget("Demos"),
            _actionWidget(
              "In SingleChildScrollView",
              () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const DemoSingleChildScrollView(),
                  ),
                );
              },
            ),
            _actionWidget(
              "In ListView (create widgets when scroll)",
              () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const DemoListView(),
                  ),
                );
              },
            ),
            _headerWidget("Settings"),
            _sliderWidget(
                "Detection interval: \n${DefaultImpressionDetectorConfig.detectionInterval.inMilliseconds}ms",
                DefaultImpressionDetectorConfig
                        .detectionInterval.inMilliseconds /
                    1000, (value) {
              DefaultImpressionDetectorConfig.detectionInterval =
                  Duration(milliseconds: (value * 1000).toInt());
              setState(() {});
            }),
            _sliderWidget(
                "Duration threshold: \n${DefaultImpressionDetectorConfig.durationThreshold.inMilliseconds}ms",
                DefaultImpressionDetectorConfig
                        .durationThreshold.inMilliseconds /
                    3000, (value) {
              DefaultImpressionDetectorConfig.durationThreshold =
                  Duration(milliseconds: (value * 3000).toInt());
              setState(() {});
            }),
            _sliderWidget(
                "Visible fraction threshold: \n${(DefaultImpressionDetectorConfig.visibleFractionThreshold * 100).toInt()}%",
                DefaultImpressionDetectorConfig.visibleFractionThreshold,
                (value) {
              // visibleFractionThreshold should > 0
              DefaultImpressionDetectorConfig.visibleFractionThreshold =
                  max(value, 0.01);
              setState(() {});
            }),
            _switchWidget(
                "Redetect when widgt left Screen",
                DefaultImpressionDetectorConfig.resetWhen
                    .contains(ImpressionDetectorReset.leftScreen), (value) {
              if (value) {
                DefaultImpressionDetectorConfig.resetWhen
                    .add(ImpressionDetectorReset.leftScreen);
              } else {
                DefaultImpressionDetectorConfig.resetWhen
                    .remove(ImpressionDetectorReset.leftScreen);
              }
              setState(() {});
            }),
            _switchWidget(
                "Redetect when app inactive",
                DefaultImpressionDetectorConfig.resetWhen
                    .contains(ImpressionDetectorReset.appInactive), (value) {
              if (value) {
                DefaultImpressionDetectorConfig.resetWhen
                    .add(ImpressionDetectorReset.appInactive);
              } else {
                DefaultImpressionDetectorConfig.resetWhen
                    .remove(ImpressionDetectorReset.appInactive);
              }
              setState(() {});
            }),
            _switchWidget(
                "Redetect when app paused",
                DefaultImpressionDetectorConfig.resetWhen
                    .contains(ImpressionDetectorReset.appPaused), (value) {
              if (value) {
                DefaultImpressionDetectorConfig.resetWhen
                    .add(ImpressionDetectorReset.appPaused);
              } else {
                DefaultImpressionDetectorConfig.resetWhen
                    .remove(ImpressionDetectorReset.appPaused);
              }
              setState(() {});
            }),
          ],
        ).toList(),
      ),
    );
  }

  Widget _headerWidget(String title) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }

  Widget _actionWidget(String title, Function() onTap) {
    return ListTile(
      title: Text(title),
      trailing: const Icon(Icons.navigate_next),
      onTap: onTap,
    );
  }

  Widget _sliderWidget(
      String title, double value, Function(double value) onChanged) {
    return ListTile(
      title: Text(title),
      trailing: SizedBox(
        width: 150,
        child: Slider(value: value, onChanged: onChanged),
      ),
    );
  }

  Widget _switchWidget(
      String title, bool value, Function(bool value) onChanged) {
    return ListTile(
      title: Text(title),
      trailing: Switch(value: value, onChanged: onChanged),
    );
  }
}
