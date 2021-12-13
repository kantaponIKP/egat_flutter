import 'dart:math';

import 'package:egat_flutter/screens/page/trade/forecast/api/forecast_api.dart';
import 'package:egat_flutter/screens/page/trade/forecast/state/forecast_date_state.dart';
import 'package:egat_flutter/screens/page/trade/forecast/state/forecast_selected_date_state.dart';
import 'package:egat_flutter/screens/page/trade/forecast/state/forecast_tradeable_time_state.dart';
import 'package:egat_flutter/screens/session.dart';
import 'package:flutter/cupertino.dart';

class ForecastState extends ChangeNotifier {
  var _dateState = ForecastDateState(
    date: DateTime.now(),
  );
  ForecastDateState get dateState => _dateState;

  Map<int, ForecastData?> _forecastDataOffsets = {};
  Map<int, ForecastData?> get forecastDataOffsets => _forecastDataOffsets;

  var _selectedDateInfo = ForecastSelectedDateState();
  ForecastSelectedDateState get selectedDateInfo => _selectedDateInfo;

  late ForecastTradeableTimeState _tradeableTime;
  ForecastTradeableTimeState get tradeableTime => _tradeableTime;

  DateTime get today => _dateState.date;

  late LoginSession _loginSession;
  LoginSession get loginSession => _loginSession;

  ForecastState({
    required LoginSession loginSession,
  }) {
    _loginSession = loginSession;

    _tradeableTime = ForecastTradeableTimeState(
      forecastState: this,
    );
  }

  setLoginSession(LoginSession loginSession) {
    _loginSession = loginSession;
  }

  selectDate(DateTime date) {
    var dateMidnight = DateTime(date.year, date.month, date.day);

    var forecastDataSelectedDate = getForecastData(dateMidnight);
    var forecastDataNextDate = getForecastData(
      dateMidnight.add(Duration(days: 1)),
    );

    _selectedDateInfo.updateSelectedDateInfo(
      date: dateMidnight,
      forecastData: forecastDataSelectedDate,
      nextDayForecastData: forecastDataNextDate,
    );

    notifyListeners();
  }

  fetchForecastsFromDate(DateTime date) async {
    final dateMidnight = DateTime(date.year, date.month, date.day).toLocal();

    final data = await forecastApi.fetchForecastDataAnd7DaysPrevious(
      startDate: dateMidnight,
      accessToken: _loginSession.info!.accessToken,
    );

    final forecasts = data.forecasts;
    Map<String, ForecastData> forecastsMap = {};
    for (var forecast in forecasts) {
      forecastsMap[forecast.date.toLocal().toIso8601String()] = forecast;
    }

    _forecastDataOffsets = {};
    for (var day = -1; day < 7; day++) {
      final date = dateMidnight.add(Duration(days: -day));
      final forecastData = forecastsMap[date.toLocal().toIso8601String()];
      _forecastDataOffsets[day] = forecastData;
    }

    selectDate(selectedDateInfo.selectedDate);

    notifyListeners();
  }

  ForecastData? getForecastData(DateTime date) {
    final dateMidnight = DateTime(date.year, date.month, date.day).toLocal();
    final todayMidnight =
        DateTime(today.year, today.month, today.day).toLocal();

    final day = dateMidnight.difference(todayMidnight).inDays.abs();

    if (!forecastDataOffsets.containsKey(day)) {
      return null;
    }

    return forecastDataOffsets[day];
  }

  init() async {
    await fetchForecastsFromDate(today);
  }
}
