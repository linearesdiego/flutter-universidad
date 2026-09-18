import 'package:flutter/material.dart';

class WelcomeGradientPage extends StatelessWidget {
  const WelcomeGradientPage({super.key});

  @override
  Widget build(BuildContext context) {
    final double anchoPantalla = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        centerTitle: true,
        toolbarHeight: 40,
        title: const Text(
          'Prácticas de Componentes',
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: -anchoPantalla * 0.35,
            left: -anchoPantalla * 0.3,
            child: _circulo(
              anchoPantalla * 0.9,
              [Colors.deepPurple, Colors.pink],
            ),
          ),
          Positioned(
            top: -anchoPantalla * 0.05,
            right: -anchoPantalla * 0.35,
            child: _circulo(
              anchoPantalla * 0.75,
              [Colors.pinkAccent, Colors.purpleAccent],
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Bienvenidos!!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Nueva Página'),
                ),
              ],
            ),
          ),
          const Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Práctica de Componentes',
                style: TextStyle(color: Colors.green, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _circulo(double size, List<Color> colors) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }
}
