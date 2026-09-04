import 'package:flutter/material.dart';

class AvatarPage extends StatelessWidget {
  const AvatarPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Avatar Page'),
        actions:[
          Container(
            padding: const EdgeInsets.only(right: 10.0),
            child: const CircleAvatar(
              backgroundImage: NetworkImage(
                'https://media.istockphoto.com/id/543042022/es/vector/hombre-de-negocios-iconos-de-perfil-hombre-avatar-imagen-dise%C3%B1o-plano-vector-de-icono.jpg?s=170667a&w=0&k=20&c=Y41Qex1UKyuPPeYo76V5RZhwHZqzTpScrwiIVWIJ8Gw=',
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 10.0),
            child: const CircleAvatar(
              backgroundColor: Colors.amber,
              child: Text('FS'),
            ),
          ),
        ],
      ),
      body: const Center(
        child: FadeInImage(
          image: NetworkImage(
            'https://media.istockphoto.com/id/543042022/es/vector/hombre-de-negocios-iconos-de-perfil-hombre-avatar-imagen-dise%C3%B1o-plano-vector-de-icono.jpg?s=170667a&w=0&k=20&c=Y41Qex1UKyuPPeYo76V5RZhwHZqzTpScrwiIVWIJ8Gw=',
          ),
          placeholder: AssetImage('assets/loading-img.gif'),
        ),
      ),
    );
  }
}
