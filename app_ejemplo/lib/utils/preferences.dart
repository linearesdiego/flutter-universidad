import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static late SharedPreferences _prefs;

  static const _claveContador = 'contador';

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static int get contador => _prefs.getInt(_claveContador) ?? 0;

  static set contador(int valor) {
    _prefs.setInt(_claveContador, valor);
  }
}
