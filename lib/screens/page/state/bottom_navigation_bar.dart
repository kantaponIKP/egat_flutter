import 'package:egat_flutter/screens/page/page_model.dart';
import 'package:flutter/cupertino.dart';

class BottomNavigationBarModel {
  final int? index;

  BottomNavigationBarModel({
    this.index,
  });
}

class BottomNavigationBarPage extends ChangeNotifier {
  BottomNavigationBarModel _info = BottomNavigationBarModel(index: 0);

  final PageModel parent;

  BottomNavigationBarPage(this.parent);

  BottomNavigationBarModel get info => _info;

  setInfo(BottomNavigationBarModel info) {
    this._info = info;
    notifyListeners();
  }

  setIndex(index) {
    setInfo(BottomNavigationBarModel(index: index));
  }

  setPageHome() {
    setIndex(0);
    parent.status.setStateHome();
  }

  setPageTrade() {
    setIndex(1);
    parent.status.setStateForecast();
  }
}
