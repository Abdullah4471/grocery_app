import 'package:shared_preferences/shared_preferences.dart';

class DarkThemePrefs {
  static const THEM_STATUS = "THEMSTATUS";
  setDarkTheme(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(THEM_STATUS, value);
  }
  Future <bool> getThem() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(THEM_STATUS) ?? false;
  }
}
