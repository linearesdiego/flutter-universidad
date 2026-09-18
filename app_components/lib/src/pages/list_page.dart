import 'package:flutter/material.dart';

import 'dart:async';

class ListaPage extends StatefulWidget {
  const ListaPage({super.key});

  @override
  ListaPageState createState() => ListaPageState();
}

class ListaPageState extends State<ListaPage> {
  final ScrollController _scrollController = ScrollController();

  final List<int> _listaNumeros = [];
  int _ultimoItem = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _agregar10();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // _agregar10();
        fetchData();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Listas'),
        ),
        body: Stack(
          children: <Widget>[_crearLista(), _crearLoading()],
        ));
  }

  Widget _crearLista() {
    return RefreshIndicator(
      onRefresh: obtenerPagina1,
      child: ListView.builder(
        controller: _scrollController,
        itemCount: _listaNumeros.length,
        itemBuilder: (BuildContext context, int index) {
          final imagen = _listaNumeros[index];

          return FadeInImage(
            image: NetworkImage('https://picsum.photos/500/300/?image=$imagen'),
            placeholder: const AssetImage('assets/jar-loading.gif'),
          );
        },
      ),
    );
  }

  Future<void> obtenerPagina1() async {
    const duration = Duration(seconds: 2);
    Timer(duration, () {
      _listaNumeros.clear();
      _ultimoItem++;
      _agregar10();
    });

    return Future.delayed(duration);
  }

  void _agregar10() {
    for (var i = 1; i < 10; i++) {
      _ultimoItem++;
      _listaNumeros.add(_ultimoItem);
    }

    setState(() {});
  }

  Future<Timer> fetchData() async {
    _isLoading = true;
    setState(() {});

    const duration = Duration(seconds: 2);
    return Timer(duration, respuestaHTTP);
  }

  void respuestaHTTP() {
    _isLoading = false;

    _scrollController.animateTo(_scrollController.position.pixels + 100,
        curve: Curves.fastOutSlowIn,
        duration: const Duration(milliseconds: 250));

    _agregar10();
  }

  Widget _crearLoading() {
    if (_isLoading) {
      return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[CircularProgressIndicator()],
          ),
          const SizedBox(height: 15.0)
        ],
      );
    } else {
      return Container();
    }
  }
}
