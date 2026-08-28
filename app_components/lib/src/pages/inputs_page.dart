import 'package:flutter/material.dart';

class InputsPage extends StatelessWidget {
  const InputsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Inputs")),
      body:Text("Inputs"),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
