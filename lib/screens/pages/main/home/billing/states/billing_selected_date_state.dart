import 'dart:async';

import 'package:egat_flutter/screens/forgot_password/widgets/forgot_password_cancellation_dialog.dart';
import 'billing_state.dart';
import 'package:flutter/cupertino.dart';

class BillingSelectedDateState extends ChangeNotifier {
  BillingState? _billingState;
  BillingState? get billingState => _billingState;

  bool _isTimeSettedToCurrentPeriod = true;
  bool get isTimeSettedToCurrentPeriod => _isTimeSettedToCurrentPeriod;

  late DateTime _selectedDate;

  DateTime get selectedDate => _selectedDate;

  BillingSelectedDateState() {
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
        _notifyParent();
      }
    }
  }

  void setBillingState(BillingState billingState) {
    if (_billingState == billingState) {
      return;
    }

    _billingState = billingState;

    _notifyParent();
  }

  _notifyParent() async {
    if (_billingState != null) {
      showLoading();

      try {
        await _billingState!.fetchBillingSummaryAtTime(selectedDate);
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
      selectedDate.hour,
    );

    updateIsDateSettedToCurrentPeriod();
    notifyListeners();
    await _notifyParent();
  }
}
