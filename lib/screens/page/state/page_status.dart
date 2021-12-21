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
  BilateralBuy,
  BilateralSell,
  BilateralLongTermBuy,
  BilateralLongTermSell,
  BilateralShortTermSell,
  PoolMarketTrade,
  PoolMarketShortTermBuy,
  PoolMarketShortTermSell,
  Signout
}

class PageStatus extends ChangeNotifier {
  PageState previousState = PageState.Home;
  PageState state = PageState.Home;
  List<PageState> stateList = [];
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

  setStateSigout() {
    _setState(PageState.Signout);
  }

  setStateForecast() {
    _setState(PageState.Forecast);
    stateList = [];
    stateList.add(PageState.Forecast);
  }

  setStateBilateralTrade() {
    _setState(PageState.BilateralTrade);
    stateList = [];
    stateList.add(PageState.BilateralTrade);
  }

  setStateBilateralBuy() {
    _setState(PageState.BilateralBuy);
    stateList.add(PageState.BilateralBuy);
  }

  setStateBilateralSell() {
    _setState(PageState.BilateralSell);
    stateList.add(PageState.BilateralSell);
  }

  setStateBilateralLongTermBuy() {
    _setState(PageState.BilateralLongTermBuy);
    stateList.add(PageState.BilateralLongTermBuy);
  }

  setStateBilateralLongTermSell() {
    _setState(PageState.BilateralLongTermSell);
    stateList.add(PageState.BilateralLongTermSell);
  }

  setStateBilateralShortTermSell() {
    _setState(PageState.BilateralShortTermSell);
    stateList.add(PageState.BilateralShortTermSell);
  }

  setStatePoolMarketTrade() {
    _setState(PageState.PoolMarketTrade);
    stateList = [];
    stateList.add(PageState.PoolMarketTrade);
  }

  setStatePoolMarketShortTermBuy() {
    _setState(PageState.PoolMarketShortTermBuy);
    stateList.add(PageState.PoolMarketShortTermBuy);
  }

  setStatePoolMarketShortTermSell() {
    _setState(PageState.PoolMarketShortTermSell);
    stateList.add(PageState.PoolMarketShortTermSell);
  }

  setStatePrevious() {
    stateList.removeLast();
    _setState(stateList.last);
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
