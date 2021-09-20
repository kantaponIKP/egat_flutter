import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLanguage extends ChangeNotifier {
  // var prefs ;
  // constructor() async {
  //   // prefs = await SharedPreferences.getInstance();
  // }
  Locale _appLocale = Locale('en');

  Locale get appLocal => _appLocale ?? Locale("en");

  fetchLocale() async {
    var prefs = await SharedPreferences.getInstance();
    var lngCode = prefs.getString('language_code');
    log('call fetchLocale language Code on load: $lngCode');
    if (prefs.getString('language_code') == null) {
      _appLocale = Locale('en');
      return Null;
    }
    _appLocale = Locale(prefs.getString('language_code')!);
    return Null;
  }

  void changeLanguage(Locale type) async {
    var prefs = await SharedPreferences.getInstance();
    log('call changeLanguage method old languade code : $_appLocale new language code $type');
    if (_appLocale == type) {
      return;
    }

    if (type == Locale('en')) {
      _appLocale = type;
      await prefs.setString('language_code', 'en');
      await prefs.setString('countryCode', 'US');
    } else {
      _appLocale = type;
      await prefs.setString('language_code', 'th');
      await prefs.setString('countryCode', '');
    }
    log('after change Language app language : $_appLocale');
    notifyListeners();
  }
}
