import 'package:flutter/material.dart';

class SliderPage extends StatelessWidget {
  const SliderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Slider - Checks")),
      body: Text("Slider - Checks"),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
