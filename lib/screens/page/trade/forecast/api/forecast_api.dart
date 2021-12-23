import 'dart:collection';
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

  asUnmodifiable() => ForecastData(
        date: date,
        forecastInGrids: UnmodifiableListView(forecastInGrids),
        powerInGrids: UnmodifiableListView(powerInGrids),
      );
}

const forecastApi = const ForecastApi();
