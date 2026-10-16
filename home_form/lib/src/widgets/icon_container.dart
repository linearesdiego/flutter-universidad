import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IconContainer extends StatelessWidget {
  final double size;
  const IconContainer({super.key, required this.size}) : assert(size > 0);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(size * 0.15),
          boxShadow: const [
            BoxShadow(
                color: Color.fromARGB(66, 186, 31, 31),
                blurRadius: 20,
                offset: Offset(0, 10)),
          ]),
      padding: EdgeInsets.all(size * 0.15),
//Se utiliza un widget Center para posicionar el icono
      child: Center(
        child: SvgPicture.asset(
          'assets/icon.svg',
//Tamaño del icono
          width: size * 0.6,
          height: size * 0.6,
        ),
      ),
    );
  }
}
