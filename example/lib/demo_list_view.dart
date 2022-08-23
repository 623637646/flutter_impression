import 'package:example/my_app_bar.dart';
import 'package:example/observed_widget.dart';
import 'package:flutter/material.dart';

class DemoListView extends StatelessWidget {
  const DemoListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(context, "SingleChildScrollView"),
      body: ListView.builder(
        itemBuilder: (context, index) => SizedBox(
          height: 100,
          child: ObservedWidget(title: "$index"),
        ),
        itemCount: 100,
      ),
    );
  }
}
