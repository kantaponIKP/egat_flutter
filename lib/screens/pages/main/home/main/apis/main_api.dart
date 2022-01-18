import 'dart:convert';

import 'package:egat_flutter/Utils/http/get.dart';
import 'package:egat_flutter/constant.dart';
import 'package:http/http.dart';

class MainHomeApi {
  Future<GetHomeResponse> getHomeDaily({
    required DateTime date,
    required String accessToken,
  }) async {
    Response response;

    var dateRequest =
        DateTime(date.year, date.month, date.day).toUtc().toIso8601String();

    var url = Uri.parse(
      "$apiBaseUrlReport/report/home/daily/$dateRequest",
    );

    response = await httpGetJson(
      url: url,
      accessToken: accessToken,
    ).timeout(Duration(seconds: 10));

    final jsonMap = json.decode(utf8.decode(response.bodyBytes));

    return GetHomeResponse.fromJson(jsonMap);
  }

  Future<GetHomeResponse> getHomeMonthly({
    required DateTime date,
    required String accessToken,
  }) async {
    Response response;

    var dateRequest = DateTime(date.year, date.month).toUtc().toIso8601String();

    var url = Uri.parse(
      "$apiBaseUrlReport/report/home/monthly/$dateRequest",
    );

    response = await httpGetJson(
      url: url,
      accessToken: accessToken,
    ).timeout(Duration(seconds: 10));

    final jsonMap = json.decode(utf8.decode(response.bodyBytes));

    return GetHomeResponse.fromJson(jsonMap);
  }
}

class GetHomeResponse {
  final double batteryInTotal;
  final double batteryOutTotal;
  final double pvTotal;
  final double gridOutTotal;
  final double gridInTotal;
  final double totalSaleForecastUnit;
  final double totalSales;
  final double totalBuys;
  final double totalRec;
  final double energyConsumption;
  final double summaryNet;
  final double accumulatedRec;
  final double totalBuyFromGrid;
  final List<double> batteryIns;
  final List<double> batteryOuts;
  final List<double> pvs;
  final List<double> gridIns;
  final List<double> gridOuts;
  final List<double> sales;
  final List<double> buys;
  final List<double> buyFromGrids;

  const GetHomeResponse({
    required this.batteryInTotal,
    required this.batteryOutTotal,
    required this.pvTotal,
    required this.gridOutTotal,
    required this.gridInTotal,
    required this.totalSaleForecastUnit,
    required this.totalSales,
    required this.totalBuys,
    required this.totalRec,
    required this.energyConsumption,
    required this.summaryNet,
    required this.accumulatedRec,
    required this.totalBuyFromGrid,
    required this.batteryIns,
    required this.batteryOuts,
    required this.pvs,
    required this.gridIns,
    required this.gridOuts,
    required this.sales,
    required this.buys,
    required this.buyFromGrids,
  });

  factory GetHomeResponse.fromJson(Map<String, dynamic> json) {
    assert(json['batteryInTotal'] is num);
    assert(json['batteryOutTotal'] is num);
    assert(json['pvTotal'] is num);
    assert(json['gridOutTotal'] is num);
    assert(json['gridInTotal'] is num);
    assert(json['totalSaleForecastUnit'] is num);
    assert(json['totalSales'] is num);
    assert(json['totalBuys'] is num);
    assert(json['totalRec'] is num);
    assert(json['energyConsumption'] is num);
    assert(json['summaryNet'] is num);
    assert(json['accumulatedRec'] is num);
    assert(json['totalBuyFromGrid'] is num);
    assert(json['batteryIns'] is List);
    assert(json['batteryOuts'] is List);
    assert(json['pvs'] is List);
    assert(json['gridIns'] is List);
    assert(json['gridOuts'] is List);
    assert(json['sales'] is List);
    assert(json['buys'] is List);
    assert(json['buyFromGrids'] is List);

    return GetHomeResponse(
      batteryInTotal: (json['batteryInTotal'] as num).toDouble(),
      batteryOutTotal: (json['batteryOutTotal'] as num).toDouble(),
      pvTotal: (json['pvTotal'] as num).toDouble(),
      gridOutTotal: (json['gridOutTotal'] as num).toDouble(),
      gridInTotal: (json['gridInTotal'] as num).toDouble(),
      totalSaleForecastUnit: (json['totalSaleForecastUnit'] as num).toDouble(),
      totalSales: (json['totalSales'] as num).toDouble(),
      totalBuys: (json['totalBuys'] as num).toDouble(),
      totalRec: (json['totalRec'] as num).toDouble(),
      energyConsumption: (json['energyConsumption'] as num).toDouble(),
      summaryNet: (json['summaryNet'] as num).toDouble(),
      accumulatedRec: (json['accumulatedRec'] as num).toDouble(),
      totalBuyFromGrid: (json['totalBuyFromGrid'] as num).toDouble(),
      batteryIns: (json['batteryIns'] as List)
          .map((e) => (e as num).toDouble())
          .toList(),
      batteryOuts: (json['batteryOuts'] as List)
          .map((e) => (e as num).toDouble())
          .toList(),
      pvs: (json['pvs'] as List).map((e) => (e as num).toDouble()).toList(),
      gridIns:
          (json['gridIns'] as List).map((e) => (e as num).toDouble()).toList(),
      gridOuts:
          (json['gridOuts'] as List).map((e) => (e as num).toDouble()).toList(),
      sales: (json['sales'] as List).map((e) => (e as num).toDouble()).toList(),
      buys: (json['buys'] as List).map((e) => (e as num).toDouble()).toList(),
      buyFromGrids: (json['buyFromGrids'] as List)
          .map((e) => (e as num).toDouble())
          .toList(),
    );
  }
}

final mainHomeApi = MainHomeApi();
