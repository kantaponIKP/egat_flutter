import 'package:egat_flutter/Utils/http/httpRefreshToken.dart';
import 'package:egat_flutter/Utils/http/httpShouldRetry.dart';
import 'package:http/http.dart';

typedef ActionRetryCallFunction = Future<Response> Function();

Future<Response> httpActionRetry({
  required ActionRetryCallFunction callFunction,
  int retryMax = 5,
  Duration timeout = const Duration(seconds: 15),
}) async {
  for (var retryCount = 0; retryCount < retryMax - 1; retryCount++) {
    try {
      final response = await callFunction();

      if (httpShouldRetry(response)) {
        await Future.delayed(Duration(milliseconds: 150 * (retryCount + 1)))
            .timeout(timeout);
        continue;
      }

      if (await httpRefreshToken(response)) {
        await Future.delayed(Duration(milliseconds: 500 * (retryCount + 1)));
        continue;
      }

      return response;
    } catch (e) {
      await Future.delayed(Duration(milliseconds: 500 * (retryCount + 1)));
      print(e);
    }
  }

  return await callFunction();
}
