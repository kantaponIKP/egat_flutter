import 'package:egat_flutter/screens/page/page_model.dart';
import 'package:flutter/cupertino.dart';

enum PageState {
  Home,
  PersonalInfo,
  ChangePassword,
  Setting,
  ContactUs,
  News,
  Graph,
  Forecast,
  BilateralTrade,
  PoolMarketTrade,
}

class PageStatus extends ChangeNotifier {
  PageState previousState = PageState.Home;
  PageState state = PageState.Home;
  final PageModel _parent;

  PageStatus(this._parent);

  setStateHome() {
    _setState(PageState.Home);
  }

  setStatePersonalInfo() {
    _setState(PageState.PersonalInfo);
  }

  setStateChangePassword() {
    _setState(PageState.ChangePassword);
  }

  setStateSetting() {
    _setState(PageState.Setting);
  }

  setStateContactUs() {
    _setState(PageState.ContactUs);
  }

  setStateNews() {
    _setState(PageState.News);
  }

  setStateGraph() {
    _setState(PageState.Graph);
  }

  setStateForecast() {
    _setState(PageState.Forecast);
  }

  setStateBilateralTrade() {
    _setState(PageState.BilateralTrade);
  }

  setStatePoolMarketTrade() {
    _setState(PageState.PoolMarketTrade);
  }
  
  _setState(PageState state) {
    if (this.previousState != this.state) {
      this.previousState = this.state;
      _parent.whenPageStatusChanged();
    }

    this.state = state;
    notifyListeners();
  }
}
