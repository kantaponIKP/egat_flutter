import 'package:flutter/cupertino.dart';

enum AddPaymentState {
  AddPayment,
  CardPayment,
  Success,
  Dismiss,
}

class AddPaymentStatus extends ChangeNotifier {
  AddPaymentState previousState = AddPaymentState.AddPayment;
  AddPaymentState state = AddPaymentState.AddPayment;

  AddPaymentStatus();

  setStateDismiss() {
    _setState(AddPaymentState.Dismiss);
  }

  setStateAddPayment() {
    _setState(AddPaymentState.AddPayment);
  }

  setStateCardPayment() {
    _setState(AddPaymentState.CardPayment);
  }

  setStateDissmiss() {
    _setState(AddPaymentState.Dismiss);
  }

  setStateSuccess() {
    _setState(AddPaymentState.Success);
  }

  _setState(AddPaymentState state) {
    if (this.previousState != this.state) {
      this.previousState = this.state;
    }

    this.state = state;
    notifyListeners();
  }
}
