import 'package:example/demo_single_child_scroll_view.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

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
            _headerWidget(context, "Demos"),
            _actionWidget(
              context,
              "SingleChildScrollView",
              () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const DemoSingleChildScrollView(),
                  ),
                );
              },
            ),
            _headerWidget(context, "Settings"),
          ],
        ).toList(),
      ),
    );
  }

  Widget _headerWidget(BuildContext context, String title) {
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

  Widget _actionWidget(BuildContext context, String title, Function() onTap) {
    return ListTile(
      title: Text(title),
      trailing: const Icon(Icons.navigate_next),
      onTap: onTap,
    );
  }
}
