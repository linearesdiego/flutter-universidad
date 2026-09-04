import 'package:flutter/material.dart';

class CardsPage extends StatelessWidget {
  const CardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cards - Tarjetas")),
      body: ListView(
        padding: const EdgeInsets.all(10.0),
        children: [
          _cardTipo1(),
          _cardTipo2(),
          _cardTipo3()
        ],
      ),);

  }

  Widget _cardTipo1(){
    return Card(
      child: Column(
        children: [
          ListTile(leading: Icon(Icons.photo_album), title: Text('Titulo de la tarjeta'), subtitle: Text("Este texto es un subtitulo"),),
          Row(mainAxisAlignment: MainAxisAlignment.end, 
          children: [
            TextButton(onPressed: (){}, child: Text("Cancelar")),
            TextButton(onPressed: (){}, child: Text("Aceptar"))
          ],
          )
        ],
      ),
    );
  }

  Widget _cardTipo2(){
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Column(
        children: [
          FadeInImage(placeholder: AssetImage("assets/loading3.gif"), image: NetworkImage("https://i.natgeofe.com/n/2a832501-483e-422f-985c-0e93757b7d84/6_3x2.jpg"),
          fadeInDuration: Duration(seconds: 2),
          height: 300,
          fit: BoxFit.cover,
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Text("Descripcion de la imagen"),
          )
        ],
      ),
    );
  }


  Widget _cardTipo3(){
    final card = Column(children: [
      FadeInImage(placeholder: AssetImage("assets/loading3.gif"), image: NetworkImage("https://i.natgeofe.com/n/2a832501-483e-422f-985c-0e93757b7d84/6_3x2.jpg"),
          fadeInDuration: Duration(seconds: 2),
          fit: BoxFit.cover,
          ),
          Container(  
            padding: EdgeInsets.all(10),
            child: Text("Descripcion de la imagen"),
          )
    ],);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
        boxShadow: [BoxShadow(
          color: Colors.black26,
          blurRadius: 10,
          spreadRadius: 2,
          offset: Offset(2, 10)
        )],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30), 
          child: card,
        ),
      );
  }
}