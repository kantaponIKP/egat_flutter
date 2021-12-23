import 'package:egat_flutter/screens/page/api/model/AccessRequest.dart';
import 'package:egat_flutter/screens/page/api/model/BilateralLongTermSellInfoRequest.dart';
import 'package:egat_flutter/screens/page/api/model/BilateralLongTermSellInfoResponse.dart';
import 'package:egat_flutter/screens/page/api/model/BilateralLongTermSellRequest.dart';
import 'package:egat_flutter/screens/page/page_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

class BilateralLongtermSellTile {
  String? time;
  int? days;
  String? startDate;
  String? endDate;
  double? energy;
  double? price;
  bool? isActive;
  List<int>? dayOptions;

  BilateralLongtermSellTile({
    this.time,
    this.days,
    this.startDate,
    this.endDate,
    this.energy,
    this.price,
    this.isActive,
    this.dayOptions,
  });

  BilateralLongtermSellTile.fromJSONMap(Map<String, dynamic> jsonMap) {
    this.time = jsonMap['time'];
    this.dayOptions = (jsonMap['dayOptions'] as List<dynamic>).map((option) => (option as num).toInt()).toList();
    if (jsonMap['startDate'] != null) {
      this.startDate = jsonMap['startDate'];
      this.endDate = jsonMap['endDate'];
      this.days = (jsonMap['days'] as num).toInt();
      this.energy = (jsonMap['energy'] as num).toDouble();
      this.price = (jsonMap['price'] as num).toDouble();
      this.isActive = true;
    }else{
      this.startDate = "";
      this.endDate = "";
      this.days = 7;
      this.energy = 0;
      this.price = 0;
      this.isActive = false;
    }
  }
}

class BilateralLongTermSellModel {
  List<BilateralLongtermSellTile>? bilateralTileList;
  String? date;
  BilateralLongTermSellModel({this.bilateralTileList, this.date});
}

class BilateralLongTermSell extends ChangeNotifier {
  BilateralLongTermSellModel _info = BilateralLongTermSellModel();

  final PageModel parent;

  BilateralLongTermSell(this.parent);

  BilateralLongTermSellModel get info => _info;

  setInfo(BilateralLongTermSellModel info) {
    this._info = info;
    notifyListeners();
  }

  Future<void> getBilateralLongTermSellInfo() async {
    DateTime now = new DateTime.now();
    DateTime date = now.add(new Duration(hours: 2));
    String dateString = date.toUtc().toIso8601String();
    BilateralLongTermSellInfoResponse response;
    response = await parent.api.getBilateralLongTermSellInfo(
        BilateralLongTermSellInfoRequest(date: dateString),
        AccessRequest(
            accessToken: parent.session.info!.accessToken,
            userId: parent.session.info!.userId));

    List<BilateralLongtermSellTile> models = [];
    for (var i = 0; i < response.bilateralList.length; i++) {
      models.add(
          BilateralLongtermSellTile.fromJSONMap(response.bilateralList[i]));
    }
    setInfo(BilateralLongTermSellModel(bilateralTileList: models, date: dateString));
  }

  
  Future<bool> bilateralLongTermSell(
      List<BilateralLongtermSellTile> list) async {
    Response response;
    response = await parent.api.bilateralLongTermSell(
      BilateralLongTermSellRequest(
        bilateralList: list,
      ),
      AccessRequest(
        accessToken: parent.session.info!.accessToken,
        userId: parent.session.info!.userId,
      ),
    );
    print(response.statusCode);
    if(response.statusCode < 300){
      return true;
    }else{
      return false;
    }
    
  }

  setPageBilateralTrade() {
    parent.status.setStateBilateralTrade();
  }

  setPageBack() {
    parent.status.setStatePrevious();
  }
}
