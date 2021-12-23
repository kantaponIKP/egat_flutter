import 'package:egat_flutter/screens/page/page_model.dart';
import 'package:flutter/cupertino.dart';

class HomeModel {
  final String? year;
  final String? month;
  final String? day;

  HomeModel({
    this.year,
    this.month,
    this.day,
  });
}

class Home extends ChangeNotifier {
  HomeModel _info = HomeModel();

  final PageModel parent;

  Home(this.parent);

  HomeModel get info => _info;

  setInfo(HomeModel info) {
    this._info = info;
    notifyListeners();
  }

  updateInfo({
    String? year,
    String? month,
    String? day,
  }) {
    if (year == null) {
      year = info.year;
    }

    if (day == null) {
      month = info.month;
    }

    if (day == null) {
      day = info.day;
    }

    var newInfo = HomeModel(
      year: year,
      month: month,
      day: day,
    );

    setInfo(newInfo);
  }

  setNoInfo() {
    this._info = HomeModel();
    notifyListeners();
  }


  setPageGraph() {
    parent.status.setStateGraph();
  }

}
