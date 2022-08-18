import 'package:flutter/material.dart';
import 'package:impression/impression.dart';

class ObservedWidget extends StatefulWidget {
  final String title;
  const ObservedWidget({super.key, required this.title});

  @override
  State<ObservedWidget> createState() => _ObservedWidgetState();
}

class _ObservedWidgetState extends State<ObservedWidget>
    with SingleTickerProviderStateMixin {
  late Animation<Color?> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: DefaultImpressionDetectorConfig.durationThreshold,
        vsync: this);
    animation =
        ColorTween(begin: Colors.red, end: Colors.green).animate(controller);
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ImpressionDetector(
      impressedCallback: () {
        debugPrint('[Debug] ${widget.title} impressed');
      },
      builder: (context, impressed, visibleFraction, keepInScreenFrom) {
        if (impressed) {
          controller.value = 1;
        } else if (keepInScreenFrom == null) {
          controller.value = 0;
        } else {
          final now = DateTime.now();
          final impressedDateTime = keepInScreenFrom
              .add(DefaultImpressionDetectorConfig.durationThreshold);
          final diff = impressedDateTime.difference(now);
          assert(!diff.isNegative &&
              diff < DefaultImpressionDetectorConfig.durationThreshold);
          controller.value = 1 -
              diff.inMilliseconds /
                  DefaultImpressionDetectorConfig
                      .durationThreshold.inMilliseconds;
          controller.forward();
        }

        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 0.1,
                ),
                color: animation.value,
              ),
              child: Stack(
                children: [
                  Center(
                    child: Text("${(visibleFraction * 100).toInt()}%"),
                  ),
                  Positioned(
                    child: Text(widget.title),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}
