import 'dart:math';

import 'package:flutter/material.dart';

class AnimatedContainerPage extends StatefulWidget {
  const AnimatedContainerPage({super.key});

  @override
  State<AnimatedContainerPage> createState() => _AnimatedContainerPageState();
}

class _AnimatedContainerPageState extends State<AnimatedContainerPage> {

  double _width= 50.0;
  double _height= 50.0;
  Color color =Colors.blue;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Animated Container")),
      body: Center(
          child: AnimatedContainer(
            duration: Duration(seconds: 5),
            width: _width,
            height: _height,
            curve: Curves.fastOutSlowIn,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20)
            ),
          ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: _cambiarForma, 
        child: Icon(Icons.play_arrow),
      ),
    );
  }

  void _cambiarForma(){
    final random = Random();
    setState(() {
      _width=random.nextInt(350).toDouble();
      _height=random.nextDouble()*100;
      color= Color.fromRGBO(random.nextInt(255), random.nextInt(255), random.nextInt(255), random.nextDouble());
    });
  }
}
