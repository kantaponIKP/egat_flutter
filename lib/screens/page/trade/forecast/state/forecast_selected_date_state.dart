import 'package:egat_flutter/screens/page/trade/forecast/api/forecast_api.dart';
import 'package:flutter/cupertino.dart';

class ForecastSelectedDateState extends ChangeNotifier {
  var _selectedDate = DateTime.now().toLocal();
  DateTime get selectedDate => _selectedDate;
  DateTime get nextDate => _selectedDate.add(Duration(days: 1));

  ForecastData? _forecastData;
  ForecastData? get forecastData => _forecastData;

  ForecastData? _nextDayForecastData;
  ForecastData? get nextDayForecastData => _nextDayForecastData;

  updateSelectedDateInfo({
    required DateTime date,
    required ForecastData? forecastData,
    required ForecastData? nextDayForecastData,
  }) {
    _selectedDate = date;
    _forecastData = forecastData;
    _nextDayForecastData = nextDayForecastData;
    notifyListeners();
  }
}
