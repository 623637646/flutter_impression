library impression;

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

enum ImpressionDetectorReset {
  leftScreen,
  appInactive,
  appPaused,
}

class DefaultImpressionDetectorConfig {
  /// The detection interval.
  /// Smaller detectionInterval means more accuracy and higher CPU consumption.
  static Duration get detectionInterval =>
      VisibilityDetectorController.instance.updateInterval;
  static set detectionInterval(Duration value) =>
      VisibilityDetectorController.instance.updateInterval = value;

  /// The default threshold of duration in the screen.
  /// The view will be impressed if it keeps being in screen after this duration.
  static Duration durationThreshold = const Duration(seconds: 1);

  /// The default threshold of area ratio in screen.
  /// The view will be impressed if it's area ratio keeps being bigger than this value.
  /// It should be > 0 and <= 1 `(0, 1]`.
  static double visibleFractionThreshold = 0.5;

  /// The default situations which will retrigger the impression event.
  static final Set<ImpressionDetectorReset> resetWhen = {
    ImpressionDetectorReset.leftScreen,
    ImpressionDetectorReset.appInactive,
    ImpressionDetectorReset.appPaused,
  };
}

class ImpressionDetector extends StatefulWidget {
  /// Child widget.
  /// It's should be null if the builder property is set.
  final Widget? child;

  /// Child widget builder.
  /// It's should be null if the child property is set.
  final Widget Function(BuildContext context, bool impressed,
      double visibleFraction, DateTime? keepInScreenFrom)? builder;

  /// impressed call back
  final VoidCallback impressedCallback;

  /// The threshold of duration in the screen for current widget.
  /// The view will be impressed if it keeps being in screen after this duration.
  /// If it's null, will use [DefaultImpressionDetectorConfig.durationThreshold]
  final Duration? durationThreshold;

  /// The threshold of area ratio in screen for current widget.
  /// The view will be impressed if it's area ratio keeps being bigger than this value.
  /// It should be > 0 and <= 1 `(0, 1]`.
  /// If it's null, will use [DefaultImpressionDetectorConfig.visibleFractionThreshold]
  final double? visibleFractionThreshold;

  /// The situations which will retrigger the impression event for current widget.
  /// If it's null, will use [DefaultImpressionDetectorConfig.resetWhen]
  final Set<ImpressionDetectorReset>? resetWhen;

  const ImpressionDetector({
    super.key,
    this.durationThreshold,
    this.visibleFractionThreshold,
    this.resetWhen,
    required this.impressedCallback,
    this.builder,
    this.child,
  }) : assert((builder == null) ^ (child == null),
            "Can't set both builder and child");

  @override
  State<ImpressionDetector> createState() => _ImpressionDetectorState();
}

class _ImpressionDetectorState extends State<ImpressionDetector>
    with WidgetsBindingObserver {
  final _key = UniqueKey();

  DateTime? _keepInScreenFrom;

  bool _isImpressed = false;

  double _visibleFraction = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.inactive:
        if (_retriggerImpression(ImpressionDetectorReset.appInactive)) {
          _reset();
        }
        break;
      case AppLifecycleState.paused:
        if (_retriggerImpression(ImpressionDetectorReset.appPaused)) {
          _reset();
        }
        break;
      case AppLifecycleState.resumed:
        _detectImpressionAndRebuildChildIfNeeded();
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: _key,
      onVisibilityChanged: (visibilityInfo) {
        final newValue = visibilityInfo.visibleFraction;
        if (_visibleFraction == newValue) {
          return;
        }
        _visibleFraction = newValue;
        _detectImpressionAndRebuildChildIfNeeded();
      },
      child: widget.builder != null
          ? widget.builder!(
              context,
              _isImpressed,
              _visibleFraction,
              _keepInScreenFrom,
            )
          : widget.child ?? Container(),
    );
  }

  void _detectImpressionAndRebuildChildIfNeeded() {
    if (!mounted) {
      return;
    }
    _detectImpression();
    _rebuildChildIfNeeded();
  }

  void _detectImpression() {
    if (_isImpressed &&
        !_retriggerImpression(ImpressionDetectorReset.leftScreen)) {
      return;
    }
    if (_visibleFraction >= _appliedVisibleFractionThreshold) {
      // It's on the screen.
      if (_isImpressed) {
        return;
      }
      if (_keepInScreenFrom == null) {
        _keepInScreenFrom = DateTime.now();
        Timer(_appliedDurationThreshold,
            _detectImpressionAndRebuildChildIfNeeded);
      } else {
        final duration = DateTime.now().difference(_keepInScreenFrom!);
        if (duration.compareTo(_appliedDurationThreshold) > 0) {
          _triggerImpression();
        }
      }
    } else {
      // it's not on the screen.
      _keepInScreenFrom = null;
      if (_retriggerImpression(ImpressionDetectorReset.leftScreen)) {
        _reset();
      }
    }
  }

  void _reset() {
    _keepInScreenFrom = null;
    _isImpressed = false;
  }

  void _triggerImpression() {
    _isImpressed = true;
    _keepInScreenFrom = null;
    widget.impressedCallback();
  }

  void _rebuildChildIfNeeded() {
    if (widget.builder == null) {
      return;
    }
    setState(() {});
  }

  bool _retriggerImpression(ImpressionDetectorReset situation) {
    final situations =
        widget.resetWhen ?? DefaultImpressionDetectorConfig.resetWhen;
    return situations.contains(situation);
  }

  double get _appliedVisibleFractionThreshold {
    final visibleFractionThreshold = widget.visibleFractionThreshold ??
        DefaultImpressionDetectorConfig.visibleFractionThreshold;
    assert(visibleFractionThreshold > 0 && visibleFractionThreshold <= 1);
    return visibleFractionThreshold;
  }

  Duration get _appliedDurationThreshold {
    final durationThreshold = widget.durationThreshold ??
        DefaultImpressionDetectorConfig.durationThreshold;
    assert(!durationThreshold.isNegative);
    return durationThreshold;
  }
}
