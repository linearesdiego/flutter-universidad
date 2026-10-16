import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
 String _nombre='';
String _fecha='';
String _email='';
final List <String> _profesiones= [
'Sin Dato',
'Doctor',
'Medico',
'Profesor',
'Gomero',
'Cartonero',
];
final TextEditingController _inputFieldController = TextEditingController();
String _opcionseleccionada ='Sin Dato';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: Text(
          "Bienvenidos al campus",
          style:
          TextStyle(color: Colors.white),),
      ),
      body:Column(
        children: [
          FadeInImage(
            placeholder: AssetImage('assets/loading-img.gif'),
            image: NetworkImage('https://tse4.mm.bing.net/th/id/OIP.kJL2KM46ggKzXdFkEfHDuAHaDz?r=0&rs=1&pid=ImgDetMain&o=7&rm=3'),
            width: 350,
            height: 200,),
          Padding(
            padding: EdgeInsets.all(50),
            child: Column(
            children: [
          _inputNombre(),
          Divider(),
          _inputEmail(),
          Divider(),
          _inputPassword(),
          Divider(),
          _crearFecha(context),
          Divider(),
          _crearDropdown(),
            ],)
          ),
          ElevatedButton(
            onPressed: _mostrarAlerta,
            child: Text("Iniciar Sesion")
            )
        ],
      ),
    );
  }

  Widget _crearFecha(BuildContext context){
    return TextField(
      enableInteractiveSelection: true,
      controller: _inputFieldController,
      decoration: InputDecoration(
        label: Text("Fecha"),
        hint: Text("Fecha"),
        icon: Icon(Icons.date_range)
      ),
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        _selectDate(context);
      },
    );
  }

  Future<DateTime?>_selectDate(BuildContext content) async{
    DateTime? calendario = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2030),
    );
    if (calendario != null) {
      setState(() {
        _fecha = calendario.toString().substring(0, 10);
        _inputFieldController.text = _fecha;
      });
    }
    return calendario;
  }


  Widget _inputNombre(){
    return TextField(
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        label: Text("Nombre completo"),
        hint: Text("Escriba su Nombre"),
        icon: Icon(Icons.accessibility),
        suffixIcon: Icon(Icons.supervised_user_circle)
      ),
        onChanged: (value) => {
          setState(() {
            _nombre=value;
          })
        },
    );
  }

  Widget _inputEmail(){
    return TextField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        label: Text("Email"),
        hint: Text("Escriba su Email"),
        icon: Icon(Icons.email)
      ),
      onChanged: (value) => {
        setState(() {
          _email=value;
        })
      },
    );
  }

  Widget _inputPassword(){
    return TextField(
      obscureText: true,
      decoration: InputDecoration(
        label: Text("Password"),
        hint: Text("Escriba su Password"),
        icon: Icon(Icons.password)
      ),
    );
  }

  List<DropdownMenuItem<String>> getOpcionesDropdown() {
    List<DropdownMenuItem<String>> lista = [];
    for (var profesion in _profesiones) {
      lista.add(DropdownMenuItem(value: profesion, child: Text(profesion)));
    }
    return lista;
  }
    Widget _crearDropdown() {
    return Row(
      children: <Widget>[
        Icon(Icons.select_all),
        SizedBox(width: 30.0),
        Expanded(
          child: DropdownButton(
            //Valor por defecto del dropdown
            value: _opcionseleccionada,
            items: getOpcionesDropdown(),
            onChanged: (opt) {
              setState(() {
                _opcionseleccionada = opt.toString();
              });
            },
          ),
        ),
      ],
    );
  }



  void _mostrarAlerta(){
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text("Bienvenido"),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("Bienvenido al campus, Registro hecho con exito"),
              Text("Nombre: $_nombre"),
              Text("Email: $_email"),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => {
                setState(() {
                  Navigator.of(context).pop();
                })
              },
              child: Text("Cancelar")),
            TextButton(
              onPressed: () => {
                setState(() {
                  Navigator.of(context).pop();
                })
              },
              child: Text("Aceptar"))
          ],
        );
      });
  }
}