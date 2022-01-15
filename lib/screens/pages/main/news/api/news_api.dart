import 'package:egat_flutter/screens/pages/main/news/api/models/NewsResponse.dart';
import 'package:egat_flutter/screens/pages/main/news/state/news_state.dart';
import 'package:http/http.dart' as http;

class NewsApi {
  Future<NewsBulletResponse> fetchNewsBulletsAtPage({
    // required int page,
    required String authToken,
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

    var bullet = NewsBullet(
      title:
          'รวมพลังกลุ่ม กฟผ. มอบเงิน 3 ล้านบาท จัดหายาฟ้าทะลายโจรช่วยผู้ป่วยโควิด-19',
      description: 'วันนี้ (13 สิงหาคม 2564) นายกิจจา ศรีพัฒากุระ กรรมการ',
      createdAt: DateTime.now(),
    );
    List<NewsBullet> news = [];
    for(int i = 0; i < 20; i++){
      NewsBullet bullet = NewsBullet(title: "Title "+i.toString(),description: "description",createdAt: DateTime.now());
      news.add(bullet);
    }
    // print("for ");
    // print([for (int i = 0; i < 4; i++) i].toString());
    return NewsBulletResponse(newsList: news);
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
