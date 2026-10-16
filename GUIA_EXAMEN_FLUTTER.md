# Guía de estudio — Examen de Flutter

## PUNTO 1 — Estructura paso a paso (orden para el examen)

### 1. Crear proyecto
```
flutter create nombre_app
cd nombre_app
```
Borra todo `lib/main.dart` y deja solo lo de abajo.

### 2. Árbol de carpetas
```
nombre_app/
├── assets/
│   └── images/
│       └── logo.png
├── lib/
│   ├── main.dart
│   └── src/
│       ├── app.dart
│       ├── routes/
│       │   └── routes.dart
│       ├── pages/
│       │   ├── home_page.dart
│       │   └── detalle_page.dart
│       └── widgets/          (opcional: componentes reutilizables)
└── pubspec.yaml
```

### 3. `lib/main.dart`
```dart
import 'package:flutter/material.dart';
import 'src/app.dart';

void main() {
  runApp(const MainApp());
}
```

### 4. `lib/src/app.dart`
```dart
import 'package:flutter/material.dart';
import 'routes/routes.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mi App',
      theme: ThemeData(colorSchemeSeed: Colors.blue),
      initialRoute: '/',
      routes: getAplicationsRoutes(),
    );
  }
}
```

### 5. `lib/src/routes/routes.dart`
```dart
import 'package:flutter/material.dart';
import '../pages/home_page.dart';
import '../pages/detalle_page.dart';

Map<String, WidgetBuilder> getAplicationsRoutes() {
  return <String, WidgetBuilder>{
    '/': (BuildContext context) => const HomePage(),
    'detalle': (BuildContext context) => const DetallePage(),
  };
}
```

### 6. Navegar entre páginas
```dart
Navigator.pushNamed(context, 'detalle');                 // ir
Navigator.pushNamed(context, 'detalle', arguments: 'Hola'); // ir con dato
Navigator.pop(context);                                  // volver

// recibir el argumento en DetallePage (dentro de build):
final dato = ModalRoute.of(context)!.settings.arguments as String;
```

### 7. Imagen local → `pubspec.yaml`
1. Crear carpeta `assets/images/` en la raíz (al lado de `lib`, NO dentro).
2. Copiar la imagen ahí.
3. En `pubspec.yaml`, dentro de `flutter:` (¡cuidado con la indentación de 2 espacios!):
```yaml
flutter:
  uses-material-design: true
  assets:
    - assets/images/          # toda la carpeta (con / al final)
    # - assets/images/logo.png  # o un archivo puntual
```
4. `flutter pub get` (o guardar el archivo) y **reiniciar la app** (hot restart, no basta hot reload).
5. Usar:
```dart
Image.asset('assets/images/logo.png', width: 150, fit: BoxFit.cover)
```
Imagen de internet (si aplica): `Image.network('https://...')`
Fondo con imagen:
```dart
Container(
  decoration: const BoxDecoration(
    image: DecorationImage(image: AssetImage('assets/images/fondo.jpg'), fit: BoxFit.cover),
  ),
)
```
Imagen redondeada: `ClipRRect(borderRadius: BorderRadius.circular(20), child: Image.asset(...))`
Avatar: `CircleAvatar(radius: 40, backgroundImage: AssetImage('assets/images/yo.png'))`

### 8. ¿Stateless o Stateful? (regla rápida)
- **StatelessWidget**: la vista no cambia (solo muestra cosas).
- **StatefulWidget**: hay algo que cambia en pantalla → contador, input que se muestra, checkbox, switch, slider, sumar carrito, mostrar/ocultar, cambiar color… → usar `setState`.
- Atajos en VS Code: escribir `stless` / `stful` + Enter.

---

## PUNTO 2 — Código para recordar

### Plantilla StatelessWidget
```dart
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inicio'), centerTitle: true),
      body: const Center(child: Text('Hola')),
    );
  }
}
```

### Plantilla StatefulWidget + lógica (contador — el clásico)
```dart
class CountPage extends StatefulWidget {
  const CountPage({super.key});

  @override
  State<CountPage> createState() => _CountPageState();
}

class _CountPageState extends State<CountPage> {
  int _contador = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contador')),
      body: Center(
        child: Text('$_contador', style: const TextStyle(fontSize: 40)),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => setState(() => _contador--),
            child: const Icon(Icons.remove),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            onPressed: () => setState(() => _contador = 0),
            child: const Icon(Icons.refresh),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            onPressed: () => setState(() => _contador++),
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
```

### Layout (lo que más se usa para copiar una vista)
```dart
Column(                                  // vertical
  mainAxisAlignment: MainAxisAlignment.center,   // eje principal (vertical)
  crossAxisAlignment: CrossAxisAlignment.start,  // eje cruzado (horizontal)
  children: [ ... ],
)
Row(                                     // horizontal
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [ ... ],
)
Expanded(child: ...)                     // ocupa el espacio que sobra (dentro de Row/Column)
SizedBox(height: 20)                     // espacio
Padding(padding: EdgeInsets.all(16), child: ...)
Center(child: ...)
Stack(children: [fondo, Positioned(top: 10, right: 10, child: ...)])  // encimar
ListView(children: [...])                // para que haga scroll
SingleChildScrollView(child: Column(...)) // Column con scroll
```
Si sale la franja amarilla/negra de "overflow" → envolver en `SingleChildScrollView` o usar `Expanded`.

### Container con estilo
```dart
Container(
  width: 200,
  height: 100,
  margin: const EdgeInsets.all(10),
  padding: const EdgeInsets.all(15),
  alignment: Alignment.center,
  decoration: BoxDecoration(
    color: Colors.blue,
    borderRadius: BorderRadius.circular(15),
    border: Border.all(color: Colors.black, width: 2),
    boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(2, 4))],
    gradient: const LinearGradient(colors: [Colors.purple, Colors.blue]), // (no usar color + gradient juntos)
  ),
  child: const Text('Hola'),
)
```
Ojo: si usas `decoration`, el `color` va DENTRO del BoxDecoration, no afuera.

### Texto
```dart
Text('Titulo',
  textAlign: TextAlign.center,
  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey[700]),
)
Text('Nombre: $_nombre')          // interpolación
Text('Total: ${_precio * _cant}') // expresión
```

### Botones
```dart
ElevatedButton(onPressed: () {}, child: const Text('Aceptar'))
TextButton(onPressed: () {}, child: const Text('Cancelar'))
OutlinedButton(onPressed: () {}, child: const Text('Otro'))
IconButton(onPressed: () {}, icon: const Icon(Icons.favorite))
ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.send), label: const Text('Enviar'))

// botón con estilo
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.green,
    foregroundColor: Colors.white,
    minimumSize: const Size(double.infinity, 50),   // ancho completo
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
  onPressed: () {},
  child: const Text('Ingresar'),
)
```

### Inputs (TextField) + mostrar lo escrito
```dart
String _nombre = '';
final TextEditingController _ctrl = TextEditingController();

TextField(
  controller: _ctrl,
  keyboardType: TextInputType.number,     // emailAddress, text...
  obscureText: false,                     // true para contraseña
  decoration: InputDecoration(
    labelText: 'Nombre',
    hintText: 'Escribe tu nombre',
    prefixIcon: const Icon(Icons.person),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
  ),
  onChanged: (valor) => setState(() => _nombre = valor),
)

// leer al apretar un botón:
final texto = _ctrl.text;
final numero = double.tryParse(_ctrl.text) ?? 0;   // texto → número
```

### Lógica típica de examen (ejemplos)
```dart
// Suma / cálculo
double _resultado = 0;
void _calcular() {
  final a = double.tryParse(_ctrlA.text) ?? 0;
  final b = double.tryParse(_ctrlB.text) ?? 0;
  setState(() => _resultado = a + b);
}

// Validar login
void _login() {
  if (_ctrlUser.text.isEmpty || _ctrlPass.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Completa todos los campos')),
    );
    return;
  }
  if (_ctrlUser.text == 'admin' && _ctrlPass.text == '1234') {
    Navigator.pushNamed(context, 'home');
  }
}

// Mostrar/ocultar
bool _visible = true;
if (_visible) const Text('Me ves')          // dentro de children: [...]
_visible ? const Text('Sí') : const Text('No')

// Cambiar color al tocar
Color _color = Colors.red;
onPressed: () => setState(() => _color = _color == Colors.red ? Colors.blue : Colors.red),

// Favorito
bool _fav = false;
IconButton(
  icon: Icon(_fav ? Icons.favorite : Icons.favorite_border, color: Colors.red),
  onPressed: () => setState(() => _fav = !_fav),
)
```

### Listas desde un arreglo
```dart
final List<String> _frutas = ['Manzana', 'Pera', 'Uva'];

ListView.builder(
  itemCount: _frutas.length,
  itemBuilder: (context, i) {
    return ListTile(
      leading: const Icon(Icons.apple),
      title: Text(_frutas[i]),
      subtitle: const Text('fruta'),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () => Navigator.pushNamed(context, 'detalle', arguments: _frutas[i]),
    );
  },
)

// con map (dentro de una Column):
Column(children: _frutas.map((f) => Text(f)).toList())

// agregar / borrar
setState(() => _frutas.add('Kiwi'));
setState(() => _frutas.removeAt(i));
```

### Lista de objetos (clase modelo simple)
```dart
class Producto {
  final String nombre;
  final double precio;
  Producto(this.nombre, this.precio);
}

final List<Producto> _productos = [Producto('Pan', 2.5), Producto('Leche', 4)];
double get total => _productos.fold(0, (suma, p) => suma + p.precio);
```

### Card
```dart
Card(
  elevation: 5,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
  child: Padding(
    padding: const EdgeInsets.all(12),
    child: Column(children: [ Image.asset('assets/images/a.png'), const Text('Título') ]),
  ),
)
```

### GridView
```dart
GridView.count(
  crossAxisCount: 2,           // columnas
  crossAxisSpacing: 10,
  mainAxisSpacing: 10,
  padding: const EdgeInsets.all(10),
  children: [ ... ],
)
```

### Otros controles con estado
```dart
bool _check = false;
Checkbox(value: _check, onChanged: (v) => setState(() => _check = v!))
SwitchListTile(title: const Text('Activar'), value: _check, onChanged: (v) => setState(() => _check = v))

double _valor = 50;
Slider(value: _valor, min: 0, max: 100, onChanged: (v) => setState(() => _valor = v))

String _opcion = 'A';
DropdownButton<String>(
  value: _opcion,
  items: ['A', 'B', 'C'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
  onChanged: (v) => setState(() => _opcion = v!),
)
```

### Alerta (dialog)
```dart
showDialog(
  context: context,
  builder: (context) => AlertDialog(
    title: const Text('Título'),
    content: const Text('Mensaje'),
    actions: [
      TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
    ],
  ),
);
```

### Scaffold completo (todas las partes)
```dart
Scaffold(
  backgroundColor: Colors.white,
  appBar: AppBar(title: const Text('X'), backgroundColor: Colors.blue, actions: [IconButton(...)]),
  drawer: Drawer(child: ListView(children: [...])),
  body: ...,
  floatingActionButton: FloatingActionButton(onPressed: () {}, child: const Icon(Icons.add)),
  bottomNavigationBar: BottomNavigationBar(
    currentIndex: _index,
    onTap: (i) => setState(() => _index = i),
    items: const [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
      BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
    ],
  ),
)
```

---

## Checklist del examen (en orden)
1. `flutter create` → crear `lib/src/{pages,routes}` y `assets/images`.
2. `main.dart` → `app.dart` → `routes.dart` → páginas.
3. Imagen: copiar a `assets/images/`, declarar en `pubspec.yaml`, hot restart.
4. Maquetar la vista con Scaffold → Column/Row → Container/Text/Image.
5. ¿Algo cambia? → StatefulWidget + variables con `_` + `setState`.
6. Probar navegación y lógica.

## Errores comunes
- Indentación mal en `pubspec.yaml` (usar 2 espacios, sin tabs) → no carga la imagen.
- Olvidar hot restart después de agregar assets.
- Usar `color:` afuera del Container cuando ya tiene `decoration:` → error.
- Cambiar variable sin `setState` → la pantalla no se actualiza.
- `Expanded` fuera de un Row/Column → error.
- ListView dentro de Column sin `Expanded` → error de altura infinita.
- Nombre de ruta mal escrito en `pushNamed` (debe ser igual al de `routes.dart`).
- Imports relativos: desde `routes/` a `pages/` es `'../pages/home_page.dart'`.

## Verificación (para practicar hoy)
Crear un proyecto nuevo `practica_examen` sin mirar este archivo: login con imagen (assets) → navega a una home con contador y una lista. Si lo logras en ~30 min, estás listo. Luego comparar con esta guía.
