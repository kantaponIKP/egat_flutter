import 'package:egat_flutter/Utils/http/refreshToken/refresh_token_api.dart';
import 'package:http/http.dart';

final httpRefreshToken = (Response response) async {
  if (response.statusCode == 401) {
    // RefreshTokenApi api = new RefreshTokenApi();
    // var result = await api.refreshToken();
    return true;
  }

  return false;
};
