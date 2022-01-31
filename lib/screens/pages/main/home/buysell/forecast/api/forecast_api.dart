import 'dart:collection';
import 'dart:convert';
import 'dart:math';

import 'package:egat_flutter/Utils/http/get.dart';
import 'package:egat_flutter/constant.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';

class ForecastApi {
  const ForecastApi();

  Future<ForecastDataResponse> fetchForecastDataAnd7DaysPrevious({
    required String accessToken,
    required DateTime startDate,
  }) async {
    Response response;

    var url = Uri.parse(
      "$apiBaseUrlReport/report/forecast/${startDate.toUtc().toIso8601String()}",
    );

    response = await httpGetJson(
      url: url,
      accessToken: accessToken,
    );

    if (response.statusCode >= 300) {
      logger.log(
        Level.debug,
        'ForecastApi.fetchForecastDataAnd7DaysPrevious: Error response from server: ${response.statusCode}',
      );
      throw Exception('Failed to fetch forecast data ${response.statusCode}');
    }

    return ForecastDataResponse.fromJson(jsonDecode(response.body));
  }

  Future<ForecastDataResponse> fetchForecastDataAnd7DaysPreviousMock({
    required String accessToken,
    required DateTime startDate,
  }) async {
    await Future.delayed(Duration(seconds: 1));

    var random = Random();
    final randomForecastDatas = <ForecastData>[];
    for (var i = -1; i < 7; i++) {
      var randomForecastValues = <double>[];
      for (var j = 0; j < 24; j++) {
        randomForecastValues.add(random.nextDouble() * 10 - 5);
      }

      var randomLoadValues = <double>[];
      for (var j = 0; j < 24; j++) {
        randomLoadValues.add(
          max(
            0,
            randomForecastValues[j] + (random.nextDouble() * 5) - 2.5,
          ),
        );
      }

      var randomPvValues = <double>[];
      for (var j = 0; j < 24; j++) {
        randomPvValues.add(
          max(
            0,
            randomForecastValues[j] + (random.nextDouble() * 5) - 2.5,
          ),
        );
      }

      final randomForecastData = ForecastData(
        date: startDate.add(Duration(days: -i)),
        forecastInGrids: randomForecastValues,
        forecastLoadInGrids: randomLoadValues,
        loadInGrids: randomLoadValues,
        forecastPvInGrids: randomPvValues,
        pvInGrids: randomPvValues,
      );
      randomForecastDatas.add(randomForecastData);
    }

    var availableTradeDateTimes = <DateTime>[];
    for (var day = 0; day < 2; day++) {
      for (var hour = 0; hour < 24; hour++) {
        var randomAvailableLogic = random.nextBool();

        if (randomAvailableLogic) {
          availableTradeDateTimes.add(
            startDate.add(
              Duration(
                days: day,
                hours: hour,
              ),
            ),
          );
        }
      }
    }

    return ForecastDataResponse(
      forecasts: randomForecastDatas,
      availableTradeDateTimes: availableTradeDateTimes,
    );
  }
}

class ForecastDataResponse {
  final List<ForecastData> forecasts;
  final List<DateTime> availableTradeDateTimes;

  const ForecastDataResponse({
    required this.forecasts,
    required this.availableTradeDateTimes,
  });

  factory ForecastDataResponse.fromJson(Map<String, dynamic> json) {
    final forecasts = (json['forecasts'] as List)
        .map((e) => ForecastData.fromJson(e))
        .toList();

    final availableTradeDateTimes = (json['availableTradeDateTimes'] as List)
        .map((e) => DateTime.parse(e))
        .toList();

    return ForecastDataResponse(
      forecasts: forecasts,
      availableTradeDateTimes: availableTradeDateTimes,
    );
  }
}

class ForecastData {
  final DateTime date;
  final List<double?> forecastInGrids;
  final List<double?> forecastLoadInGrids;
  final List<double?> loadInGrids;
  final List<double?> forecastPvInGrids;
  final List<double?> pvInGrids;

  const ForecastData({
    required this.date,
    required this.forecastInGrids,
    required this.forecastLoadInGrids,
    required this.loadInGrids,
    required this.forecastPvInGrids,
    required this.pvInGrids,
  });

  asUnmodifiable() => ForecastData(
        date: date,
        forecastInGrids: UnmodifiableListView(forecastInGrids),
        forecastLoadInGrids: UnmodifiableListView(forecastLoadInGrids),
        loadInGrids: UnmodifiableListView(loadInGrids),
        forecastPvInGrids: UnmodifiableListView(forecastPvInGrids),
        pvInGrids: UnmodifiableListView(pvInGrids),
      );

  factory ForecastData.fromJson(Map<String, dynamic> jsonMap) {
    assert(jsonMap['date'] is String);
    assert(jsonMap['forecastInGrids'] is List);
    assert(jsonMap['forecastLoadInGrids'] is List);
    assert(jsonMap['loadInGrids'] is List);
    assert(jsonMap['forecastPvInGrids'] is List);
    assert(jsonMap['pvInGrids'] is List);

    final date = DateTime.parse(jsonMap['date']);
    final forecastInGrids = jsonMap['forecastInGrids'] as List<dynamic>;
    final forecastLoadInGrids = jsonMap['forecastLoadInGrids'] as List<dynamic>;
    final loadInGrids = jsonMap['loadInGrids'] as List<dynamic>;
    final forecastPvInGrids = jsonMap['forecastPvInGrids'] as List<dynamic>;
    final pvInGrids = jsonMap['pvInGrids'] as List<dynamic>;

    return ForecastData(
      date: date,
      forecastInGrids: forecastInGrids.map((e) {
        if (e != null) {
          return (e as num).toDouble();
        } else {
          return null;
        }
      }).toList(),
      forecastLoadInGrids: forecastLoadInGrids.map((e) {
        if (e != null) {
          return (e as num).toDouble();
        } else {
          return null;
        }
      }).toList(),
      loadInGrids: loadInGrids.map((e) {
        if (e != null) {
          return (e as num).toDouble();
        } else {
          return null;
        }
      }).toList(),
      forecastPvInGrids: forecastPvInGrids.map((e) {
        if (e != null) {
          return (e as num).toDouble();
        } else {
          return null;
        }
      }).toList(),
      pvInGrids: pvInGrids.map((e) {
        if (e != null) {
          return (e as num).toDouble();
        } else {
          return null;
        }
      }).toList(),
    );
  }
}

const forecastApi = const ForecastApi();
