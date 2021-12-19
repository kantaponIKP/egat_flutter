import 'dart:async';

import 'package:egat_flutter/screens/forgot_password/widgets/forgot_password_cancellation_dialog.dart';
import 'package:flutter/cupertino.dart';

import 'bilateral_state.dart';

class BilateralSelectedTimeState extends ChangeNotifier {
  BilateralState? _bilateralState;
  BilateralState? get bilateralState => _bilateralState;

  bool _isTimeSettedToCurrentPeriod = true;
  bool get isTimeSettedToCurrentPeriod => _isTimeSettedToCurrentPeriod;

  late DateTime _selectedTime;

  DateTime get selectedTime => _selectedTime;

  BilateralSelectedTimeState() {
    _setDefaultSelectedTime(notify: false);

    Timer.periodic(
      Duration(seconds: 60),
      (timer) {
        _checkSelectedTime();
        _notifyParent();
      },
    );
  }

  void _checkSelectedTime() {
    if (_isTimeSettedToCurrentPeriod) {
      _setDefaultSelectedTime();
    }
  }

  void _setDefaultSelectedTime({
    bool notify = true,
  }) {
    final now = DateTime.now();

    if (now.hour > 16) {
      _selectedTime = DateTime(now.year, now.month, now.day, 18);
    } else if (now.hour < 4) {
      _selectedTime = DateTime(now.year, now.month, now.day - 1, 18);
    } else {
      _selectedTime = DateTime(now.year, now.month, now.day, 6);
    }

    _isTimeSettedToCurrentPeriod = true;

    if (notify) {
      final previousSelectedTime = _selectedTime;
      if (previousSelectedTime.difference(_selectedTime).inSeconds > 0) {
        notifyListeners();
        _notifyParent();
      }
    }
  }

  void setBilateralState(BilateralState bilateralState) {
    if (_bilateralState == bilateralState) {
      return;
    }

    _bilateralState = bilateralState;

    _notifyParent();
  }

  _notifyParent() async {
    if (_bilateralState != null) {
      showLoading();

      try {
        await _bilateralState!.fetchTradeAtTime(selectedTime);
      } finally {
        hideLoading();
      }
    }
  }

  updateIsTimeSettedToCurrentPeriod() {
    final now = DateTime.now();

    final start = _selectedTime;
    final limit = start.add(Duration(hours: 12));

    final startDiff = now.difference(start);
    final limitDiff = now.difference(limit);

    if (startDiff.inHours.abs() < 12 && limitDiff.inHours.abs() < 12) {
      _isTimeSettedToCurrentPeriod = true;
    } else {
      _isTimeSettedToCurrentPeriod = false;
    }
  }

  setSelectedTime(DateTime selectedTime) async {
    _selectedTime = DateTime(
      selectedTime.year,
      selectedTime.month,
      selectedTime.day,
      selectedTime.hour,
    );

    updateIsTimeSettedToCurrentPeriod();
    notifyListeners();
    await _notifyParent();
  }
}
