import 'dart:collection';

import 'package:egat_flutter/screens/session.dart';
import 'package:flutter/cupertino.dart';

import '../api/forecast_api.dart';
import 'forecast_date_state.dart';
import 'forecast_selected_date_state.dart';
import 'forecast_tradeable_time_state.dart';

class ForecastState extends ChangeNotifier {
  ForecastDateState _dateState = ForecastDateState(date: DateTime.now());

  Map<int, ForecastData?> _forecastDataOffsets = {};
  ForecastSelectedDateState _selectedDateInfo = ForecastSelectedDateState();

  List<DateTime> _availableDateTime = [];
  late ForecastTradeableTimeState _tradeableTime;

  ReadonlyLoginSession? _loginSession;
  ForecastState() {
    _tradeableTime = ForecastTradeableTimeState(forecastState: this);
  }

  UnmodifiableListView<DateTime> get availableDateTime =>
      UnmodifiableListView(_availableDateTime);
  ForecastDateState get dateState => _dateState;

  Map<int, ForecastData?> get forecastDataOffsets => _forecastDataOffsets;
  ReadonlyLoginSession? get loginSession => _loginSession;

  ForecastSelectedDateState get selectedDateInfo => _selectedDateInfo;
  DateTime get today => _dateState.date;

  ForecastTradeableTimeState get tradeableTime => _tradeableTime;

  fetchForecastsFromDate(DateTime date) async {
    if (_loginSession == null) {
      throw new Exception('Login session state is not provided');
    }

    final dateMidnight = DateTime(date.year, date.month, date.day).toLocal();

    final data = await forecastApi.fetchForecastDataAnd7DaysPrevious(
      startDate: dateMidnight,
      accessToken: _loginSession!.info!.accessToken,
    );

    final forecasts = data.forecasts;
    Map<String, ForecastData> forecastsMap = {};
    for (var forecast in forecasts) {
      forecastsMap[forecast.date.toLocal().toIso8601String()] = forecast;
    }

    _forecastDataOffsets = {};
    _availableDateTime = [];

    for (var day = -1; day < 7; day++) {
      final date = dateMidnight.add(Duration(days: -day));
      final forecastData = forecastsMap[date.toLocal().toIso8601String()];
      _forecastDataOffsets[day] = forecastData?.asUnmodifiable();
    }

    _availableDateTime = List<DateTime>.from(data.availableTradeDateTimes);

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

  selectDate(DateTime date) {
    var dateMidnight = DateTime(date.year, date.month, date.day);
    var today = this.today;
    var todayMidnight = DateTime(today.year, today.month, today.day);

    var forecastDataSelectedDate = getForecastData(dateMidnight);
    var forecastDataNextDate = getForecastData(
      dateMidnight.add(Duration(days: 1)),
    );

    if (dateMidnight == todayMidnight) {
      _selectedDateInfo.updateSelectedDateInfo(
        date: dateMidnight,
        forecastData: forecastDataSelectedDate,
        nextDayForecastData: forecastDataNextDate,
        availableDateTimes: availableDateTime,
      );
    } else {
      _selectedDateInfo.updateSelectedDateInfo(
        date: dateMidnight,
        forecastData: forecastDataSelectedDate,
        nextDayForecastData: forecastDataNextDate,
        availableDateTimes: availableDateTime,
      );
    }
  }

  setLoginSession(LoginSession loginSession) {
    _loginSession = loginSession.asReadonly();
  }
}
