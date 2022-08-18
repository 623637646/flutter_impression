import 'dart:math';
import 'package:example/demo_app_bar.dart';
import 'package:example/observed_widget.dart';
import 'package:flutter/material.dart';

class DemoSingleChildScrollView extends StatelessWidget {
  const DemoSingleChildScrollView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: demoAppBar(context, "SingleChildScrollView"),
      body: SingleChildScrollView(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            4,
            (column) => Expanded(
              child: Column(
                children: List.generate(
                  40,
                  (row) => SizedBox(
                    height: Random().nextInt(100) + 100,
                    child: ObservedWidget(title: "$column-$row"),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
