class BilateralBuyItem {
  final String id;
  final String sellerId;
  final double lat;
  final double lng;
  final String name;
  final DateTime date;
  final double energyToBuy;
  final double estimatedBuy;
  final double netEnergyPrice;
  final double energyTariff;
  final double energyPrice;
  final double wheelingChargeTariff;
  final double wheelingCharge;
  final double tradingFee;
  final double vat;
  final bool isLongterm;
  final String? buyerId;
  final bool isBuyable;

  BilateralBuyItem({
    required this.id,
    required this.sellerId,
    required this.lat,
    required this.lng,
    required this.name,
    required this.date,
    required this.energyToBuy,
    required this.estimatedBuy,
    required this.netEnergyPrice,
    required this.energyTariff,
    required this.energyPrice,
    required this.wheelingChargeTariff,
    required this.wheelingCharge,
    required this.tradingFee,
    required this.vat,
    required this.isLongterm,
    required this.buyerId,
    required this.isBuyable,
  });

  factory BilateralBuyItem.fromJSON(Map<String, dynamic> jsonMap) {
    assert(jsonMap['id'] is String);
    assert(jsonMap['sellerId'] is String);
    assert(jsonMap['lat'] is num);
    assert(jsonMap['lng'] is num);
    assert(jsonMap['name'] is String);
    assert(jsonMap['date'] is String);
    assert(jsonMap['energyToBuy'] is num);
    assert(jsonMap['estimatedBuy'] is num);
    assert(jsonMap['netEnergyPrice'] is num);
    assert(jsonMap['energyTariff'] is num);
    assert(jsonMap['energyPrice'] is num);
    assert(jsonMap['wheelingChargeTariff'] is num);
    assert(jsonMap['wheelingCharge'] is num);
    assert(jsonMap['tradingFee'] is num);
    assert(jsonMap['vat'] is num);
    assert(jsonMap['isLongterm'] is bool);

    if (jsonMap['buyerId'] is String) {
      assert(jsonMap['buyerId'] is String);
    }
    assert(jsonMap['isBuyable'] is bool);

    return BilateralBuyItem(
      id: jsonMap['id'],
      sellerId: jsonMap['sellerId'],
      lat: (jsonMap['lat'] as num).toDouble(),
      lng: (jsonMap['lng'] as num).toDouble(),
      name: jsonMap['name'],
      date: DateTime.parse(jsonMap['date']).toLocal(),
      energyToBuy: (jsonMap['energyToBuy'] as num).toDouble(),
      estimatedBuy: (jsonMap['estimatedBuy'] as num).toDouble(),
      netEnergyPrice: (jsonMap['netEnergyPrice'] as num).toDouble(),
      energyTariff: (jsonMap['energyTariff'] as num).toDouble(),
      energyPrice: (jsonMap['energyPrice'] as num).toDouble(),
      wheelingChargeTariff: (jsonMap['wheelingChargeTariff'] as num).toDouble(),
      wheelingCharge: (jsonMap['wheelingCharge'] as num).toDouble(),
      tradingFee: (jsonMap['tradingFee'] as num).toDouble(),
      vat: (jsonMap['vat'] as num).toDouble(),
      isLongterm: jsonMap['isLongterm'],
      buyerId: jsonMap['buyerId'],
      isBuyable: jsonMap['isBuyable'],
    );
  }
}
