class BilateralLongtermSellInfo {
  final DateTime time;
  final DateTime? startDate;
  final int? days;
  final DateTime? endDate;
  final double? energy;
  final double? price;
  final List<int> dayOptions;

  BilateralLongtermSellInfo({
    required this.time,
    required this.startDate,
    required this.days,
    required this.endDate,
    required this.energy,
    required this.price,
    required this.dayOptions,
  });

  factory BilateralLongtermSellInfo.fromJSON(Map<String, dynamic> json) {
    assert(json['time'] is String);

    if (json['startDate'] != null) {
      assert(json['startDate'] is String);
    }

    if (json['days'] != null) {
      assert(json['days'] is num);
    }

    if (json['endDate'] != null) {
      assert(json['endDate'] is String);
    }

    if (json['energy'] != null) {
      assert(json['energy'] is num);
    }

    if (json['price'] != null) {
      assert(json['price'] is num);
    }

    if (json['dayOptions'] != null) {
      assert(json['dayOptions'] is List);
    }

    return BilateralLongtermSellInfo(
      time: DateTime.parse(json['time'] as String),
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate']).toLocal()
          : null,
      days: (json['days'] as num?)?.toInt(),
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate']).toLocal()
          : null,
      energy: (json['energy'] as num?)?.toDouble(),
      price: (json['price'] as num?)?.toDouble(),
      dayOptions: (json['dayOptions'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
    );
  }
}

class BilateralLongTermSellInfoResponse {
  late List<BilateralLongtermSellInfo> bilateralList;

  BilateralLongTermSellInfoResponse({
    required this.bilateralList,
  });

  BilateralLongTermSellInfoResponse.fromJSON(List<dynamic> jsonMap) {
    this.bilateralList = [];

    for (final map in jsonMap) {
      this.bilateralList.add(BilateralLongtermSellInfo.fromJSON(map));
    }
  }
}
