import 'package:flutter/cupertino.dart';

class ForecastDateState extends ChangeNotifier {
  late DateTime _date;

  ForecastDateState({
    required date,
  }) {
    _date = date;
  }

  DateTime get date => _date;

  set date(DateTime value) {
    _date = value.toLocal();
    notifyListeners();
  }
}
