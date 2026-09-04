import 'package:flutter/material.dart';

class InputsPage extends StatefulWidget {
  const InputsPage({super.key});

  @override
  State<InputsPage> createState() => _InputsPageState();
}

class _InputsPageState extends State<InputsPage> {
  String _nombre = '';
  String _email = '';
  String _fecha = '';
  List<String> _profesiones=['Sin dato',
    'Contador',
    'Abogado',
    'Ingeniero',
    'Periodista',
    'Programador'];
    String opcionesSeleccionada='Sin dato';
  TextEditingController _inputFieldController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Inputs Page")),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        children: [
          _crearinput(),
          Divider(),
          _crearinputEmail(),
          Divider(),
          _crearinputPassword(),
          Divider(),
          _crearFecha(),
          Divider(),
          _crearDropDown(),
          _crearPersona(),
        ],
      ),
    );
  }

  Widget _crearinput() {
    return TextField(
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        counter: Text('Letras: ${_nombre.length}'),
        hintText: 'Nombre de la persona',
        labelText: 'Nombre',
        helperText: 'Solo colocar Nombre',
        suffixIcon: Icon(Icons.accessibility),
        icon: Icon(Icons.account_circle),
      ),
      onChanged: (valor) {
        setState(() {
          _nombre = valor;
        });
      },
    );
  }

  Widget _crearinputEmail() {
    return TextField(
      keyboardType: TextInputType.emailAddress,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        counter: Text('Letras: ${_nombre.length}'),
        hintText: 'Correo de la persona',
        labelText: 'Correo',
        helperText: 'Solo colocar Correo',
        suffixIcon: Icon(Icons.email),
        icon: Icon(Icons.email_outlined),
      ),
      onChanged: (valor) {
        setState(() {
          _email = valor;
        });
      },
    );
  }

  Widget _crearinputPassword() {
    return TextField(
      obscureText: true,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        counter: Text('Letras: ${_nombre.length}'),
        hintText: 'Contraseña',
        labelText: 'Contraseña',
        helperText: 'Solo colocar contraseña',
        suffixIcon: Icon(Icons.lock),
        icon: Icon(Icons.lock_open_outlined),
      ),
    );
  }

  Widget _crearFecha() {
    return TextField(
      enableInteractiveSelection: false,
      controller: _inputFieldController,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
        hintText: 'Fecha de nacimiento',
        labelText: 'Fecha de nacimiento',
        suffixIcon: const Icon(Icons.perm_contact_calendar),
        icon: const Icon(Icons.calendar_today),
      ),

      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        _selectDate(context);
      },
    );
  }

  _selectDate(BuildContext context) async {
    DateTime? calendario = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2018),
      lastDate: DateTime.now(),
    );

    if (calendario != null) {
      setState(() {
        _fecha = calendario.toString();
        _inputFieldController.text = _fecha;
      });
    }
  }

  List<DropdownMenuItem<String>> getOpciones(){
    return _profesiones.map((profesion) {
      return DropdownMenuItem(value: profesion, child: Text(profesion));
       }
    ).toList();
  }
  Widget _crearDropDown(){
    return Row(
      children: [
        Icon(Icons.select_all),
        SizedBox(width: 30.0,),
        Expanded(child:DropdownButton(items: getOpciones(), value:opcionesSeleccionada ,onChanged: (valor)=> {
          setState(() {
            opcionesSeleccionada=valor.toString();
          })
        }))
      ],
    );
  }
  Widget _crearPersona() {
    return ListTile(
      title: Text("Nombre: $_nombre"),
      subtitle: Text("Email: $_email"),
    );
  }
}