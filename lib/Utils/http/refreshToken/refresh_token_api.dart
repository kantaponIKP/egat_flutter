import 'dart:async';
import 'package:egat_flutter/Utils/http/post.dart';
import 'package:egat_flutter/Utils/http/refreshToken/RefreshTokenRequest.dart';
import 'package:egat_flutter/Utils/http/refreshToken/RefreshTokenResponse.dart';
import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/errors/IntlException.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class RefreshTokenApi {
  Future<Response> refreshToken(RefreshTokenRequest request) async {
    var url = Uri.parse(
      "$apiBaseUrlLogin/refreshToken",
    );

    var requestJson = request.toJSON();

    // final httpRequest = httpPostJson(uri: url, body: requestJson);

    final httpRequest = http.post(
        url,
        headers: {
          'Authorization': 'Bearer ${request.accessToken}',
          'Content-Type': 'application/json',
        },
        body: requestJson,
    );

    Response response;
    
    try {
      response = await httpRequest.timeout(Duration(seconds: 60));
    } on TimeoutException catch (_) {
      throw IntlException(
        message: "Time out",
        intlMessage: "error-timeoutError",
      );
    }

    // if (response.statusCode >= 500) {
    //   return response;
    // }
    // if (response.statusCode >= 300) {
    //   return response;
    // }

    // return RefreshTokenResponse.fromJSON(response.body);
    return response;
  }
}
