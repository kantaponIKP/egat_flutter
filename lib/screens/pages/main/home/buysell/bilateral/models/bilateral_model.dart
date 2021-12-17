import 'package:intl/intl.dart';

enum BilateralTradeItemType {
  BUY,
  SELL,
}

enum BilateralTradeItemStatus {
  OPEN,
  MATCHED,
  CLOSE,
}

class BilateralTradeItemModel {
  late BilateralTradeItemType type; //offer to sell or choose to buy
  late DateTime time;
  late int offerCount;
  double? amount;
  double? price;
  late BilateralTradeItemStatus status;
  late bool isLongterm;

  String get isoDate => time.toIso8601String();

  BilateralTradeItemModel({
    required this.type,
    required this.time,
    required this.status,
    required this.offerCount,
    required this.isLongterm,
    this.amount = 0,
    this.price = 0,
  });

  BilateralTradeItemModel.fromJSON(Map<String, dynamic> jsonMap) {
    assert(
      jsonMap['time'] is String,
      "time is not string",
    );

    DateTime time;
    try {
      time = DateTime.parse(jsonMap["time"]).toLocal();
    } catch (e) {
      assert(
        false,
        "time is not valid format.",
      );
      return;
    }
    this.time = time;

    assert(
      jsonMap['type'] is String,
      "type is not string",
    );
    final type = jsonMap['type'] as String;
    switch (type.toLowerCase()) {
      case "buy":
        this.type = BilateralTradeItemType.BUY;
        break;
      case "sell":
        this.type = BilateralTradeItemType.SELL;
        break;
      default:
        assert(
          false,
          "type is not valid.",
        );
        return;
    }

    assert(
      jsonMap['offerCount'] is int,
      "offerCount is not int",
    );
    this.offerCount = (jsonMap['offerCount'] as num).toInt();

    if (jsonMap.containsKey('amount')) {
      assert(
        jsonMap['amount'] is num,
        "amount is not num",
      );
      this.amount = (jsonMap['amount'] as num).toDouble();
    }

    if (jsonMap.containsKey('price')) {
      assert(
        jsonMap['price'] is num,
        "price is not num",
      );
      this.price = (jsonMap['price'] as num).toDouble();
    }

    assert(
      jsonMap['status'] is String,
      "status is not string",
    );
    final status = (jsonMap['status'] as String);
    switch (status.toLowerCase()) {
      case "open":
        this.status = BilateralTradeItemStatus.OPEN;
        break;
      case "matched":
        this.status = BilateralTradeItemStatus.MATCHED;
        break;
      case "close":
        this.status = BilateralTradeItemStatus.CLOSE;
        break;
      default:
        assert(
          false,
          "status is not valid",
        );
        return;
    }

    if (jsonMap.containsKey('isLongterm')) {
      assert(
        jsonMap['isLongterm'] is bool,
        "isLongterm is not bool",
      );
      this.isLongterm = jsonMap['isLongterm'] as bool;
    }
  }
}
