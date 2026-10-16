import 'package:flutter/material.dart';

class Circle extends StatelessWidget {
//Variable para tamaño del círculo
  final double size;
//Variable para lista de colores
  final List<Color> colors;
//Constructor del círculo
//Se agrega la directiva required para que el campo size sea //obligatorio
  const Circle({super.key, required this.size, required this.colors})
//Se agrega validación a través de un assert
      : assert(size > 0),
        assert(colors.length >= 2);
  @override
  Widget build(BuildContext context) {
    return Container(
//Se define el tamaño del círculo
      width: size,
      height: size,
      decoration: BoxDecoration(
//Se establece el color de la figura y la dirección del gradiente
          gradient: LinearGradient(
              colors: colors,
              begin: Alignment.bottomLeft,
              end: Alignment.center),
//Se establece la forma de la figura
          shape: BoxShape.circle),
    );
  }
}
