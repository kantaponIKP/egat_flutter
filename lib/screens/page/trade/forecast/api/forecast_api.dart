import 'dart:math';

class ForecastApi {
  const ForecastApi();

  Future<ForecastDataResponse> fetchForecastDataAnd7DaysPrevious({
    required String accessToken,
    required DateTime startDate,
  }) async {
    // TODO: real data
    var random = Random();
    final randomForecastDatas = <ForecastData>[];
    for (var i = -1; i < 7; i++) {
      var randomForecastValues = <double>[];
      for (var j = 0; j < 24; j++) {
        randomForecastValues.add(random.nextDouble() * 10 - 5);
      }

      var randomPowerValues = <double>[];
      for (var j = 0; j < 24; j++) {
        randomPowerValues.add(
          max(
            0,
            randomForecastValues[j] + (random.nextDouble() * 5) - 2.5,
          ),
        );
      }

      final randomForecastData = ForecastData(
        date: startDate.add(Duration(days: -i)),
        forecastInGrids: randomForecastValues,
        powerInGrids: randomPowerValues,
      );
      randomForecastDatas.add(randomForecastData);
    }

    return ForecastDataResponse(
      forecasts: randomForecastDatas,
    );
  }
}

class ForecastDataResponse {
  final List<ForecastData> forecasts;

  const ForecastDataResponse({
    required this.forecasts,
  });
}

class ForecastData {
  final DateTime date;
  final List<double?> forecastInGrids;
  final List<double?> powerInGrids;

  const ForecastData({
    required this.date,
    required this.forecastInGrids,
    required this.powerInGrids,
  });
}

const forecastApi = const ForecastApi();
