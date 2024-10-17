import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static const String _idIdosoKey = 'id_idoso';
  static const String _idProfissionalKey = 'id_profissional';

  static Future<void> saveIdIdoso(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_idIdosoKey, id);
  }

  static Future<void> saveIdProfissional(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_idProfissionalKey, id);
  }

  static Future<String?> getIdIdoso() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_idIdosoKey);
  }

  static Future<String?> getIdProfissional() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_idProfissionalKey);
  }

  static Future<void> clearPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_idIdosoKey);
    await prefs.remove(_idProfissionalKey);
  }
}
