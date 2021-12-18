import 'dart:async';

import 'package:flutter/cupertino.dart';

import 'forecast_state.dart';

class ForecastTradeableTimeState extends ChangeNotifier {
  DateTime _forecastTradeableTime = DateTime.now().add(Duration(hours: 2));
  DateTime get forecastTradeableTime => _forecastTradeableTime;

  late Timer _timer;

  ForecastState forecastState;

  ForecastTradeableTimeState({
    required this.forecastState,
  }) {
    _timer = Timer.periodic(Duration(seconds: 15), (timer) {
      updateTradableTime();
    });
  }

  void updateTradableTime() {
    var oldTimeStartHour = DateTime(
      _forecastTradeableTime.year,
      _forecastTradeableTime.month,
      _forecastTradeableTime.day,
      _forecastTradeableTime.hour,
    );

    var newTime = DateTime.now().add(Duration(hours: 2));

    var newTimeStartHour = DateTime(
      newTime.year,
      newTime.month,
      newTime.day,
      newTime.hour,
    );

    if (oldTimeStartHour != newTimeStartHour) {
      _forecastTradeableTime = newTime;
      forecastState.fetchForecastsFromDate(DateTime.now());
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _timer.cancel();

    super.dispose();
  }
}
