import 'package:egat_flutter/Utils/http/httpShouldRetry.dart';
import 'package:egat_flutter/screens/login/api/login_api.dart';
import 'package:egat_flutter/screens/login/api/model/RefreshTokenRequest.dart';
import 'package:egat_flutter/screens/session.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';

GetIt getIt = GetIt.instance;

typedef ActionRetryCallFunction = Future<Response> Function();

LoginApi api = LoginApi();

Future<Response> httpActionRetry({
  required ActionRetryCallFunction callFunction,
  int retryMax = 3,
  Duration timeout = const Duration(seconds: 7),
  bool haveAuth = false,
}) async {
  GlobalLoginSession loginSession = getIt.get<GlobalLoginSession>();

  for (var retryCount = 0; retryCount < retryMax - 1; retryCount++) {
    try {
      final response = await callFunction();

      if (response.statusCode == 403) {
        var response = await api.requestRefreshToken(
          RefreshTokenRequest(
            refreshToken: loginSession.info!.refreshToken,
          ),
        );

        loginSession.setAccessToken(LoginSessionInfo(
            accessToken: response.accessToken!,
            userId: response.userId!,
            refreshToken: response.refreshToken!));

        final storage = new FlutterSecureStorage();
        await storage.write(key: 'refreshToken', value: response.refreshToken!);
      }

      if (httpShouldRetry(response)) {
        await Future.delayed(Duration(milliseconds: 150 * (retryCount + 1)))
            .timeout(timeout);
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
