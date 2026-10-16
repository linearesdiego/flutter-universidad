import 'package:flutter/material.dart';

import '../utils/login_form.dart';
import '../widgets/circle.dart';
import '../widgets/icon_container.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    //Se utiliza las reglas de MediaQuery para obtener las dimensiones del
    //dispositivo
    final Size size = MediaQuery.of(context).size;
    //Se establece el tamaño de las esferas de la interfaz para poder //reutilizar en el varias partes del código
    final double pinkSize = size.width * 0.8;
    final double orangeSize = size.width * 0.57;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            //Widget para establecer la posición del círculo
            Positioned(
              //Parámetros de posición del objeto
              top: -pinkSize * 0.5,
              right: -pinkSize * 0.2,
              child: Circle(
                //Se utiliza el valor calculado de la pantalla en vez de un
                //valor fijo. Para este caso, se calcula el tamaño de pantalla
                //por 0.8, es decir, el 80% del tamaño de pantalla
                //size: 320,
                size: pinkSize,
                colors: const [Colors.pinkAccent, Colors.pink],
              ),
            ),
            Positioned(
              //Parámetros de posición del objeto
              top: -orangeSize * 0.55,
              left: -orangeSize * 0.15,
              child: Circle(
                //size: 240,
                size: orangeSize,
                colors: const [Colors.orange, Colors.deepOrangeAccent],
              ),
            ),
            //Ícono centrado en la parte superior del formulario
            Positioned(
              top: size.height * 0.1,
              width: size.width,
              child: Center(
                child: IconContainer(size: size.width * 0.3),
              ),
            ),
            //Formulario de inicio de sesión
            const LoginForm(),
          ],
        ),
      ),
    );
  }
}
