class BilateralSellItem {
  final double lat;
  final double lng;
  final String name;
  final String date;
  final double energy;
  final double price;
  final String sellerId;
  final bool isLongterm;
  final String? buyerId;

  BilateralSellItem({
    required this.lat,
    required this.lng,
    required this.name,
    required this.date,
    required this.energy,
    required this.price,
    required this.sellerId,
    required this.isLongterm,
    required this.buyerId,
  });

  factory BilateralSellItem.fromJSON(Map<String, dynamic> jsonMap) {
    assert(jsonMap['lat'] is num);
    assert(jsonMap['lng'] is num);
    assert(jsonMap['name'] is String);
    assert(jsonMap['date'] is String);
    assert(jsonMap['energy'] is num);
    assert(jsonMap['price'] is num);
    assert(jsonMap['sellerId'] is String);
    assert(jsonMap['isLongterm'] is bool);

    if (jsonMap['buyerId'] != null) {
      assert(jsonMap['buyerId'] is String);
    }

    return BilateralSellItem(
      lat: jsonMap['lat'],
      lng: jsonMap['lng'],
      name: jsonMap['name'],
      date: jsonMap['date'],
      energy: (jsonMap['energy'] as num).toDouble(),
      price: (jsonMap['price'] as num).toDouble(),
      sellerId: jsonMap['sellerId'],
      isLongterm: jsonMap['isLongterm'],
      buyerId: jsonMap['buyerId'],
    );
  }
}
