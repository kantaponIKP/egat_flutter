import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant.dart';

class AppLocale extends ChangeNotifier {
  Locale _appLocale = Locale('en');

  Locale get locale => _appLocale;

  AppLocale.fromPreferredAppLanguage(PreferredAppLanguage preferedAppLanguage) {
    this.fromPreferredAppLanguage(preferedAppLanguage);
  }

  setLocale(Locale type) {
    // logger.d(
    //     'call changeLanguage method old languade code : $_appLocale new language code $type');
    if (_appLocale == type) {
      return;
    }

    if (type == Locale('en')) {
      _appLocale = type;
    } else {
      _appLocale = type;
    }
    // logger.d('after change Language app language : $_appLocale');
    notifyListeners();
  }

  void changeLanguage(Locale type) async {
    var prefs = await SharedPreferences.getInstance();
    // logger.d(
    //     'call changeLanguage method old languade code : $locale new language code $type');
    if (locale == type) {
      return;
    }

    if (type == Locale('en')) {
      setLocale(type);
      await prefs.setString('language_code', 'en');
      await prefs.setString('countryCode', 'US');
    } else {
      setLocale(type);
      await prefs.setString('language_code', 'th');
      await prefs.setString('countryCode', '');
    }
    // logger.d('after change Language app language : $locale');
  }

  void fromPreferredAppLanguage(PreferredAppLanguage preferedAppLanguage) {
    setLocale(preferedAppLanguage.locale);
  }
}

class PreferredAppLanguage {
  Locale _appLocale = Locale('en');

  Locale get locale => _appLocale;

  PreferredAppLanguage._();

  static createInstance() async {
    var instance = new PreferredAppLanguage._();
    var prefs = await SharedPreferences.getInstance();
    var lngCode = prefs.getString('language_code');
    // logger.d('call fetchLocale language Code on load: $lngCode');
    if (prefs.getString('language_code') == null) {
      instance._appLocale = Locale('en');
      return instance;
    }
    instance._appLocale = Locale(prefs.getString('language_code')!);
    return instance;
  }
}
