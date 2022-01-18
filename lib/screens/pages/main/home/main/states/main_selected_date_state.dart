import 'dart:async';

import 'package:egat_flutter/screens/forgot_password/widgets/forgot_password_cancellation_dialog.dart';
import 'package:flutter/cupertino.dart';

import 'main_state.dart';

enum _Mode { DAILY, MONTHLY }

class MainHomeSelectedDateState extends ChangeNotifier {
  bool _isTimeSettedToCurrentPeriod = true;
  bool get isTimeSettedToCurrentPeriod => _isTimeSettedToCurrentPeriod;

  late DateTime _selectedDate;

  DateTime get selectedDate => _selectedDate;

  _Mode _mode = _Mode.DAILY;
  bool get isDaily => _mode == _Mode.DAILY;
  bool get isMonthly => _mode == _Mode.MONTHLY;

  MainHomeState? _mainHomeState;
  setMainHomeState(MainHomeState mainHomeState) {
    _mainHomeState = mainHomeState;
  }

  setDaily() {
    _mode = _Mode.DAILY;
    notifyListeners();
    notifyParent();
  }

  setMonthly() {
    _mode = _Mode.MONTHLY;
    notifyListeners();
    notifyParent();
  }

  MainHomeSelectedDateState() {
    _setDefaultSelectedTime(notify: false);

    Timer.periodic(
      Duration(seconds: 60),
      (timer) {
        _checkSelectedDate();
      },
    );
  }

  void _checkSelectedDate() {
    if (_isTimeSettedToCurrentPeriod) {
      _setDefaultSelectedTime();
    }
  }

  void _setDefaultSelectedTime({
    bool notify = true,
  }) {
    final now = DateTime.now();

    _selectedDate = DateTime(now.year, now.month, now.day);
    _isTimeSettedToCurrentPeriod = true;

    if (notify) {
      final previousSelectedTime = _selectedDate;
      if (previousSelectedTime.difference(_selectedDate).inSeconds > 0) {
        notifyListeners();
        notifyParent();
      }
    }
  }

  notifyParent() async {
    if (_mainHomeState != null) {
      showLoading();

      try {
        await _mainHomeState!.fetch(selectedDate, isDaily);
      } finally {
        hideLoading();
      }
    }
  }

  updateIsDateSettedToCurrentPeriod() {
    final now = DateTime.now();

    final start = _selectedDate;
    final limit = start.add(Duration(hours: 24));

    final startDiff = now.difference(start);
    final limitDiff = now.difference(limit);

    if (startDiff.inHours < 24 && limitDiff.inHours < 24) {
      _isTimeSettedToCurrentPeriod = true;
    } else {
      _isTimeSettedToCurrentPeriod = false;
    }
  }

  setSelectedDate(DateTime selectedDate) async {
    _selectedDate = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );

    updateIsDateSettedToCurrentPeriod();
    notifyListeners();
    await notifyParent();
  }
}
