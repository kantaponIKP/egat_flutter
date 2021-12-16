import 'dart:collection';

import 'package:egat_flutter/screens/page/trade/forecast/api/forecast_api.dart';
import 'package:flutter/cupertino.dart';

class ForecastSelectedDateState extends ChangeNotifier {
  var _selectedDate = DateTime.now().toLocal();
  DateTime get selectedDate => _selectedDate;
  DateTime get nextDate => _selectedDate.add(Duration(days: 1));

  ForecastData? _forecastData;
  ForecastData? get forecastData => _forecastData?.asUnmodifiable();

  ForecastData? _nextDayForecastData;
  ForecastData? get nextDayForecastData =>
      _nextDayForecastData?.asUnmodifiable();

  List<DateTime> _availableDateTimes = [];
  List<DateTime> get availableDateTimes =>
      UnmodifiableListView(_availableDateTimes);

  updateSelectedDateInfo({
    required DateTime date,
    required ForecastData? forecastData,
    required ForecastData? nextDayForecastData,
    required List<DateTime> availableDateTimes,
  }) {
    _selectedDate = date;
    _forecastData = forecastData?.asUnmodifiable();
    _nextDayForecastData = nextDayForecastData?.asUnmodifiable();
    _availableDateTimes = availableDateTimes;
    notifyListeners();
  }
}
