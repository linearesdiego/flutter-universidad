import 'package:flutter/material.dart';
import '../provider/menu_provider.dart';
import '../utils/icon_string_util.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Widget> _listaitem(List<dynamic> data, BuildContext context) {
    return data
        .map(
          (dat) => Column(
            children: [
              ListTile(
                title: Text(dat['texto']),
                leading: getIcon(dat['icon']),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.pushNamed(context, dat['ruta']);
                },
              ),
              Divider(),
            ],
          ),
        )
        .toList();
  }

  Widget _lista() {
    return FutureBuilder(
      future: menuProvider.cargarData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return ListView(children: _listaitem(snapshot.data , context));
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _lista(),
    );
  }
}