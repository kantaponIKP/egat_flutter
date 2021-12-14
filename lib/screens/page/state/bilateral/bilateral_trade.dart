import 'dart:convert';

import 'package:egat_flutter/screens/page/api/model/AccessRequest.dart';
import 'package:egat_flutter/screens/page/api/model/BilateralTradeRequest.dart';
import 'package:egat_flutter/screens/page/api/model/BilateralTradeResponse.dart';
import 'package:egat_flutter/screens/page/page_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

class BilateralModel {
  String? type; //offer to sell or choose to buy
  String? time;
  int? offerCount;
  double? amount;
  double? price;
  String? status;
  String? isoDate;
  bool? isLongterm;

  BilateralModel({
    this.type = "",
    this.time = "",
    this.status = "",
    this.amount = 0,
    this.price = 0,
    this.offerCount = 0,
    this.isoDate = "",
    this.isLongterm = false,
    
  });

  BilateralModel.fromJSONMap(Map<String, dynamic> jsonMap) {
    final isoTime = DateTime.parse(jsonMap["time"]);

    final startTime = isoTime.toLocal();
    final endTime = startTime.add(Duration(hours: 1));

    final timeFormat = DateFormat("HH:mm");
    final timeText =
        "${timeFormat.format(startTime)}-${timeFormat.format(endTime)}";

    this.type = jsonMap['type'];
    this.time = timeText;
    this.offerCount = (jsonMap['offerCount'] as num).toInt();
    if (jsonMap['amount'] != null) {
      this.amount = (jsonMap['amount'] as num).toDouble();
    }
    if (jsonMap['price'] != null) {
      this.price = (jsonMap['price'] as num).toDouble();
    }
    this.status = jsonMap['status'];
    this.isoDate = jsonMap["time"];
    this.isLongterm = jsonMap["isLongterm"];
  }
}

class BilateralTradeModel {
  List<BilateralModel>? bilateralTileList;
  BilateralTradeModel({this.bilateralTileList});
}

class BilateralTrade extends ChangeNotifier {
  BilateralTradeModel _info = BilateralTradeModel();

  final PageModel parent;

  BilateralTrade(this.parent);

  BilateralTradeModel get info => _info;

  setInfo(BilateralTradeModel info) {
    this._info = info;
    notifyListeners();
  }

  updateInfo() {}

  setNoInfo() {
    this._info = BilateralTradeModel();
    notifyListeners();
  }

  setPageBilateralBuy() {
    parent.status.setStateBilateralBuy();
  }

  setPageBilateralSell() {
    parent.status.setStateBilateralSell();
  }

  Future<void> getBilateral({required String date}) async {
    BilateralTradeResponse response;
    response = await parent.api.getBilateralTrade(
        BilateralTradeRequest(date: date),
        AccessRequest(
            accessToken: parent.session.info!.accessToken,
            userId: parent.session.info!.userId));

    List<BilateralModel> models = [];
    for (var i = 0; i < response.bilateralList.length; i++) {
      models.add(BilateralModel.fromJSONMap(response.bilateralList[i]));
    }

    setInfo(BilateralTradeModel(bilateralTileList: models));
  }

//  Future<bool> resetPassword(String password) async {
//     if (parent.session.info == null) {
//       // This must not happened.
//       return false;
//     }

//     var result = await parent.api.changeForgotPassword(
//         ChangeForgotPasswordRequest(
//           sessionId: parent.session.info!.sessionId,
//           sessionToken: parent.session.info!.sessionToken,
//           email: parent.email.info.email!,
//           password: password,
//         ));

//     nextPage();

//     return false;
//   }
}
