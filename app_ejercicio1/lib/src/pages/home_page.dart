import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final int _numero2 = 2;
  List<int> resultados = [];

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }
 void _decrementCounter() {
    setState(() {
      _counter--;
    });
  }

   void _multiplicar(){
    setState(() {
      _counter = _counter * _numero2;
    });
  }

  void _counterReinicio () {
    setState(() {
      _counter = 0;
    });
  }

  void addListNumber(){
    setState(() {
      resultados.add(_counter);
    });
  }

  void removeLista(){
    setState(() {
      resultados =[];
    });
  }
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
       
        backgroundColor: Theme.of(context).colorScheme.primary,
       
        title: Center(child: Text(widget.title)),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: .center,
          children: [
            const Text('Numero de click: '),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 10,),

            Text('Resultados guardados: ${resultados.join(', ')}'),
            SizedBox(height: 10,),
            ElevatedButton(onPressed: _multiplicar, child: Text('Multiplicar por 2')),
            SizedBox(height: 10,),
            ElevatedButton(onPressed: addListNumber, child: Text('Guardar resultados')),
            SizedBox(height: 10,),
            ElevatedButton(onPressed: removeLista, child: Text('Vaciar lista')),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
          SizedBox(height: 20),
           FloatingActionButton(
            onPressed: _decrementCounter,
            tooltip: 'Decrement',
            child: const Icon(Icons.remove),
          ),
          SizedBox(height: 20),

          FloatingActionButton(
            onPressed: _counterReinicio,
            tooltip: 'backCero',
            child: Text("0"),
          ),
        ],
      ),
    );
  }
}
