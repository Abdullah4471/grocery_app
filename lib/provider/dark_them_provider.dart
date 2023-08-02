

import 'package:flutter/cupertino.dart';
import 'package:grocery_app/services/dark_theme_prefre.dart';

class DarkThemeProvider with ChangeNotifier{
  DarkThemePrefs darkThemePrefs =DarkThemePrefs();
  bool  _darkTheme= false;
  bool get getDarkTheme=> _darkTheme;


  set setDarkThem(bool value){
    _darkTheme = value;
    darkThemePrefs.setDarkTheme(value);
    notifyListeners();
  }


}