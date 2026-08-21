import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int contador = 0;

  void incrementar(){
    setState(() {
      contador++;
    });
  }

  void _mostrarAlerta(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true, // Permite cerrar la alerta al tocar fuera
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Valor no permitido'),
        content: const Text('El contador no puede tener valores negativos.'),
        actions: <Widget>[
          TextButton( 
            child: const Text('Cerrar'),
            onPressed: () {
              Navigator.of(context).pop(); // Cierra la alerta
            },
          ),
        ],
      );
    },
  );
}
  void decrementar(BuildContext context){
    if(contador <= 0) {
      _mostrarAlerta(context);
      return;
    }
    setState(() {
      contador--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.teal[50],
        body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text('El contador tiene')),
          Text('$contador'),
          FloatingActionButton(onPressed: ()=> {},)
          
        ],
      ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: 'incrementar',
              onPressed: incrementar,
              backgroundColor: Colors.deepPurple,
              child: Icon(Icons.add, color: Colors.white),
            ),
            SizedBox(height: 12),
            FloatingActionButton(
              heroTag: 'decrementar',
              onPressed: () => decrementar(context),
              backgroundColor: Colors.deepPurple,
              child: Icon(Icons.remove, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
