library impression;

import 'package:flutter/material.dart';

class Impression extends StatefulWidget {
  final Widget? child;

  const Impression({super.key, this.child});

  @override
  State<Impression> createState() => _ImpressionState();
}

class _ImpressionState extends State<Impression> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: widget.child,
    );
  }
}
