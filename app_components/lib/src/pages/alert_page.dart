import 'package:flutter/material.dart';

class AlertPage extends StatelessWidget {
  const AlertPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Alertas")),
      body: Center(
        child: ElevatedButton(onPressed: () => _mostrarAlerta(context), child: Text("Alerta")),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }



  void _mostrarAlerta(BuildContext context){
      showDialog(context: context,barrierDismissible: false ,builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          title: Text("Alerta"),
          content: Column(
            mainAxisSize: .min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Contenido"),
              FlutterLogo(
                size: 100,
              ),

            ],
          ),
            actions: [TextButton(onPressed: (){Navigator.pop(context);}, child: Text("Cancelar")),]
        );
      });
  }
}
