import 'package:egat_flutter/screens/page/api/model/AccessRequest.dart';
import 'package:egat_flutter/screens/page/api/model/BilateralShortTermSellInfoRequest.dart';
import 'package:egat_flutter/screens/page/api/model/BilateralShortTermSellInfoResponse.dart';
import 'package:egat_flutter/screens/page/page_model.dart';
import 'package:flutter/cupertino.dart';

class BilateralSellTile {
  double? lat;
  double? lng;
  String? name;
  String? date;
  double? energy;
  double? price;
  String? sellerId;
  bool? isLongterm;
  String? buyerId;

  BilateralSellTile({
    this.lat,
    this.lng,
    this.name,
    this.date,
    this.energy,
    this.price,
    this.sellerId,
    this.isLongterm,
    this.buyerId,
  });

  BilateralSellTile.fromJSONMap(Map<String, dynamic> jsonMap) {
    this.lat = (jsonMap['lat'] as num).toDouble();
    this.lng = (jsonMap['lng'] as num).toDouble();
    this.name = jsonMap['name'];
    this.date = jsonMap['date'];
    this.energy = (jsonMap['energy'] as num).toDouble();
    this.price = (jsonMap['price'] as num).toDouble();
    this.sellerId = jsonMap['sellerId'];
    this.isLongterm = jsonMap['isLongterm'];
    this.buyerId = jsonMap['buyerId'];
  }
} 

class BilateralSellModel {
  List<BilateralSellTile>? bilateralTileList;
  String? date;
  BilateralSellModel({this.bilateralTileList, this.date});
}

class BilateralSell extends ChangeNotifier {
  BilateralSellModel _info = BilateralSellModel();

  final PageModel parent;

  BilateralSell(this.parent);

  BilateralSellModel get info => _info;

  setInfo(BilateralSellModel info) {
    this._info = info;
    notifyListeners();
  }

  void updateInfo({String? date, List<BilateralSellTile>? bilateralTileList}) {
    if (date == null) {
      date = info.date;
    }
    if (bilateralTileList == null) {
      bilateralTileList = info.bilateralTileList;
    }

    var newInfo = BilateralSellModel(
      bilateralTileList: bilateralTileList,
      date: date,
    );

    setInfo(newInfo);
  }

  Future<void> getBilateralShortTermSellInfo({required String date}) async {
    BilateralShortTermSellInfoResponse response;
    response = await parent.api.getBilateralShortTermSellInfo(
        BilateralShortTermSellInfoRequest(date: date),
        AccessRequest(
            accessToken: parent.session.info!.accessToken,
            userId: parent.session.info!.userId));

    List<BilateralSellTile> models = [];
    for (var i = 0; i < response.bilateralList.length; i++) {
      models.add(BilateralSellTile.fromJSONMap(response.bilateralList[i]));
    }
    setInfo(BilateralSellModel(bilateralTileList: models, date: date));
  }

  setPageBilateralShortTermSell() {
    parent.status.setStateBilateralShortTermSell();
  }

  setPageBilateralLongTermSell() {
    parent.status.setStateBilateralLongTermSell();
  }

  setPageBack() {
    parent.status.setStatePrevious();
  }

  setPageBilateralTrade() {
    parent.status.setStateBilateralTrade();
  }
}
