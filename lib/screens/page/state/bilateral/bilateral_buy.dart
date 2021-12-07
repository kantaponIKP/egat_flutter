import 'package:egat_flutter/screens/page/api/model/AccessRequest.dart';
import 'package:egat_flutter/screens/page/api/model/BilateralShortTermBuyInfoRequest.dart';
import 'package:egat_flutter/screens/page/api/model/BilateralShortTermBuyInfoResponse.dart';
import 'package:egat_flutter/screens/page/api/model/BilateralShortTermBuyRequest.dart';
import 'package:egat_flutter/screens/page/page_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

class BilateralBuyTile {
  String? id;
  String? sellerId;
  double? lat;
  double? lng;
  String? name;
  String? date;
  double? energyToBuy;
  double? estimatedBuy;
  double? netEnergyPrice;
  double? energyTariff;
  double? energyPrice;
  double? wheelingChargeTariff;
  double? wheelingCharge;
  double? tradingFee;
  double? vat;
  bool? isLongterm;
  String? buyerId;
  bool? isBuyable;

  BilateralBuyTile({
    this.id,
    this.sellerId,
    this.lat,
    this.lng,
    this.name,
    this.date,
    this.energyToBuy,
    this.estimatedBuy,
    this.netEnergyPrice,
    this.energyTariff,
    this.energyPrice,
    this.wheelingChargeTariff,
    this.wheelingCharge,
    this.tradingFee,
    this.vat,
    this.isLongterm,
    this.buyerId,
    this.isBuyable,
  });

  BilateralBuyTile.fromJSONMap(Map<String, dynamic> jsonMap) {
    this.id = jsonMap['id'];
    this.sellerId = jsonMap['sellerId'];
    this.lat = (jsonMap['lat'] as num).toDouble();
    this.lng = (jsonMap['lng'] as num).toDouble();
    this.name = jsonMap['name'];
    this.date = jsonMap['date'];
    this.energyToBuy = (jsonMap['energyToBuy'] as num).toDouble();
    this.estimatedBuy = (jsonMap['estimatedBuy'] as num).toDouble();
    this.netEnergyPrice = (jsonMap['netEnergyPrice'] as num).toDouble();
    this.energyTariff = (jsonMap['energyTariff'] as num).toDouble();
    this.energyPrice = (jsonMap['energyPrice'] as num).toDouble();
    this.wheelingChargeTariff =
        (jsonMap['wheelingChargeTariff'] as num).toDouble();
    this.wheelingCharge = (jsonMap['wheelingCharge'] as num).toDouble();
    this.tradingFee = (jsonMap['tradingFee'] as num).toDouble();
    this.vat = (jsonMap['vat'] as num).toDouble();
    this.isLongterm = jsonMap['isLongterm'];
    this.buyerId = jsonMap['buyerId'];
    this.isBuyable = jsonMap['isBuyable'];
  }
}

class BilateralBuyModel {
  List<BilateralBuyTile>? bilateralTileList;
  String? date;
  BilateralBuyModel({this.bilateralTileList, this.date});
}

class BilateralBuy extends ChangeNotifier {
  BilateralBuyModel _info = BilateralBuyModel();

  final PageModel parent;

  BilateralBuy(this.parent);

  BilateralBuyModel get info => _info;

  setInfo(BilateralBuyModel info) {
    this._info = info;
    notifyListeners();
  }

  Future<void> getBilateralShortTermBuyInfo({required String date}) async {
    BilateralShortTermBuyInfoResponse response;
    response = await parent.api.getBilateralShortTermBuyInfo(
        BilateralShortTermBuyInfoRequest(date: date),
        AccessRequest(
            accessToken: parent.session.info!.accessToken,
            userId: parent.session.info!.userId));

    List<BilateralBuyTile> models = [];
    for (var i = 0; i < response.bilateralList.length; i++) {
      models.add(BilateralBuyTile.fromJSONMap(response.bilateralList[i]));
    }
    print("date");
    print(date);
    setInfo(BilateralBuyModel(bilateralTileList: models, date: date));
  }

  Future<bool> bilateralShortTermBuy(String id) async {
    Response response;
    response = await parent.api.bilateralShortTermBuy(
      BilateralShortTermBuyRequest(
        id: id,
      ),
      AccessRequest(
        accessToken: parent.session.info!.accessToken,
        userId: parent.session.info!.userId,
      ),
    );
    print(response.statusCode);
    if (response.statusCode < 300) {
      return true;
    } else {
      return false;
    }
  }

  setPageBilateralLongTermBuy() {
    parent.status.setStateBilateralLongTermBuy();
  }

  setPageBack() {
    parent.status.setStatePrevious();
  }

  setPageBilateralTrade() {
    parent.status.setStateBilateralTrade();
  }
}
