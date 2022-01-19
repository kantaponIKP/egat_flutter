import 'dart:async';
import 'dart:convert';

import 'package:egat_flutter/Utils/http/get.dart';
import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/errors/IntlException.dart';
import 'package:egat_flutter/screens/pages/main/news/api/models/NewsResponse.dart';
import 'package:egat_flutter/screens/pages/main/news/state/news_state.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class NewsApi {
  Future<NewsBulletResponse> fetchNewsBullets({
    // required int page,
    required authToken,
  }) async {
    // TODO: real one
    // if (page >= 4) {
    //   print("page >= 4");
    //   return NewsBulletFetchResponse(
    //     newsBullets: [NewsBullet(
    //   title:
    //       'รวมพลังกลุ่ม กฟผ. มอบเงิน 3 ล้านบาท จัดหายาฟ้าทะลายโจรช่วยผู้ป่วยโควิด-19',
    //   description: 'วันนี้ (14 สิงหาคม 2564) นายกิจจา ศรีพัฒากุระ กรรมการ',
    //   createdAt: DateTime.now(),
    // )],
    //     page: page,
    //     totalPage: 4,
    //   );
      
    // }
        var url = Uri.parse(
      "$apiBaseUrlNew/mobile/news",
    );

    final httpRequest = httpGetJson(url: url,accessToken: authToken);

    Response response;
    try {
      response = await httpRequest.timeout(Duration(seconds: 60));
    } on TimeoutException catch (_) {
      throw IntlException(
        message: "Time out",
        intlMessage: "error-timeoutError",
      );
    }

    if (response.statusCode >= 500) {
      throw IntlException(
        message: "ปฎิเสธ server ตอบกลับด้วยสถานะ ${response.statusCode}",
        intlMessage: "error-connectionError",
      );
    }
    if (response.statusCode == 401) {
      throw IntlException(
        message: "ปฎิเสธ server ตอบกลับด้วยสถานะ ${response.statusCode}",
        intlMessage: "error-sessionExpired",
      );
    }

    return NewsBulletResponse.fromJSON(utf8.decode(response.bodyBytes));
    // NewsBulletFetchResponse(newsBullets: [
    //   for (int i = 0; i < 4; i++) bullet,
    // ], totalPage: 10);
    // return NewsBulletFetchResponse(newsBullets: news,totalPage: 10);
    
  }
}

// class NewsBulletFetchResponse {
//   final List<NewsBullet> newsBullets;
//   // final int page;
//   final int totalPage;

//   const NewsBulletFetchResponse({
//     required this.newsBullets,
//     // required this.page,
//     required this.totalPage,
//   });
// }

// class NewsBullet {
//   final String title;
//   final String description;
//   final DateTime createdAt;

//   NewsBullet({
//     required this.title,
//     required this.description,
//     required this.createdAt,
//   });
// }

final newsApi = NewsApi();
