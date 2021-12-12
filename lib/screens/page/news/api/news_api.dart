import 'package:http/http.dart' as http;

class NewsApi {
  Future<NewsBulletFetchResponse> fetchNewsBulletsAtPage({
    required int page,
    required String authToken,
  }) async {
    // TODO: real one
    if (page >= 4) {
      return NewsBulletFetchResponse(
        newsBullets: [],
        page: page,
        totalPage: 4,
      );
    }

    var bullet = NewsBullet(
      title:
          'รวมพลังกลุ่ม กฟผ. มอบเงิน 3 ล้านบาท จัดหายาฟ้าทะลายโจรช่วยผู้ป่วยโควิด-19',
      description: 'description',
      createdAt: DateTime.now(),
    );

    return NewsBulletFetchResponse(newsBullets: [
      for (int i = 0; i < 4; i++) bullet,
    ], page: page, totalPage: 4);
  }
}

class NewsBulletFetchResponse {
  final List<NewsBullet> newsBullets;
  final int page;
  final int totalPage;

  const NewsBulletFetchResponse({
    required this.newsBullets,
    required this.page,
    required this.totalPage,
  });
}

class NewsBullet {
  final String title;
  final String description;
  final DateTime createdAt;

  NewsBullet({
    required this.title,
    required this.description,
    required this.createdAt,
  });
}

final newsApi = NewsApi();
