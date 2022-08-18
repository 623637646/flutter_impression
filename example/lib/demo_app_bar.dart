import 'package:flutter/material.dart';

AppBar demoAppBar(BuildContext context, String title) {
  return AppBar(
    title: Text(title),
    actions: [
      TextButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => Scaffold(
                appBar: AppBar(),
                body: Container(
                  color: Colors.white,
                ),
              ),
            ),
          );
        },
        child: const Text(
          "Next Page",
          style: TextStyle(color: Colors.white),
        ),
      ),
    ],
  );
}
