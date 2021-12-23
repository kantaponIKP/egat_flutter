import 'package:egat_flutter/screens/page/api/model/AccessRequest.dart';
import 'package:egat_flutter/screens/page/api/model/BilateralLongTermBuyInfoRequest.dart';
import 'package:egat_flutter/screens/page/api/model/BilateralLongTermBuyInfoResponse.dart';
import 'package:egat_flutter/screens/page/api/model/BilateralLongTermBuyRequest.dart';
import 'package:egat_flutter/screens/page/api/model/BilateralLongTermSellInfoRequest.dart';
import 'package:egat_flutter/screens/page/api/model/BilateralShortTermBuyInfoResponse.dart';
import 'package:egat_flutter/screens/page/page_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

class BilateralLongtermBuyTile {
  String? id;
  String? name;
  String? time;
  double? energyToBuy;
  double? netEnergyPrice;
  double? energyTariff;
  double? wheelingChargeTariff;
  double? tradingFee;

  BilateralLongtermBuyTile({
    this.id,
    this.name,
    this.time,
    this.energyToBuy,
    this.netEnergyPrice,
    this.energyTariff,
    this.wheelingChargeTariff,
    this.tradingFee,
  });

  BilateralLongtermBuyTile.fromJSONMap(Map<String, dynamic> jsonMap) {
    this.id = jsonMap['id'];
    this.name = jsonMap['name'];
    this.time = jsonMap['time'];
    this.energyToBuy = (jsonMap['energyToBuy'] as num).toDouble();
    this.netEnergyPrice = (jsonMap['netEnergyPrice'] as num).toDouble();
    this.energyTariff = (jsonMap['energyTariff'] as num).toDouble();
    this.wheelingChargeTariff =
        (jsonMap['wheelingChargeTariff'] as num).toDouble();
    this.tradingFee = (jsonMap['tradingFee'] as num).toDouble();
  }
}

class BilateralLongTermBuyModel {
  List<BilateralLongtermBuyTile>? bilateralTileList;
  String? date;
  BilateralLongTermBuyModel({this.bilateralTileList, this.date});
}

class BilateralLongTermBuy extends ChangeNotifier {
  BilateralLongTermBuyModel _info = BilateralLongTermBuyModel();

  final PageModel parent;

  BilateralLongTermBuy(this.parent);

  BilateralLongTermBuyModel get info => _info;

  setInfo(BilateralLongTermBuyModel info) {
    this._info = info;
    notifyListeners();
  }

  Future<void> getBilateralLongTermBuyInfo(DateTime date, int days) async {
    BilateralLongTermBuyInfoResponse response;
    response = await parent.api.getBilateralLongTermBuyInfo(
        BilateralLongTermBuyInfoRequest(date: date.toString(),days: days),
        AccessRequest(
            accessToken: parent.session.info!.accessToken,
            userId: parent.session.info!.userId));

    List<BilateralLongtermBuyTile> models = [];
    for (var i = 0; i < response.bilateralList.length; i++) {
      models
          .add(BilateralLongtermBuyTile.fromJSONMap(response.bilateralList[i]));
    }
    setInfo(
        BilateralLongTermBuyModel(bilateralTileList: models, date: info.date!));
  }
  // _info.bilateralTileList = [
  //   BilateralBuyTile(
  //     name: "Prosumer P02",
  //     date: "14:23,20 Aug",
  //     energyToBuy: 8.00,
  //     netEnergyPrice: 1.5,
  //     energyTariff: 2.0,
  //     wheelingChargeTariff: 1.3,
  //     tradingFee: 1.5,
  //   ),
  //   BilateralBuyTile(
  //     name: "Prosumer P13",
  //     date: "14:23,20 Aug",
  //     energyToBuy: 2.43,
  //     netEnergyPrice: 1.5,
  //     energyTariff: 1.1,
  //     wheelingChargeTariff: 1.3,
  //     tradingFee: 1.5,
  //   )
  // ];

  Future<bool> bilateralLongTermBuy(
      BilateralLongtermBuyTile bilateralBuyTileList) async {
    // var response = await parent.api.buyLongTermBilateral(BilateralLongTermBuyRequest(), AccessRequest(
    //       accessToken: "accessToken",
    //       userId: "userId",
    //     ),);

    Response response;
    response = await parent.api.bilateralLongTermBuy(
      BilateralLongTermBuyRequest(
        id: bilateralBuyTileList.id!,
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

  setPageBilateralTrade() {
    parent.status.setStateBilateralTrade();
  }

  setPageBack() {
    parent.status.setStatePrevious();
  }
}
