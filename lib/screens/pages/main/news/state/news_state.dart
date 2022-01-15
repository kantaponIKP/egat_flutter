import 'package:egat_flutter/screens/pages/main/news/api/models/NewsResponse.dart';
import 'package:egat_flutter/screens/session.dart';
import 'package:flutter/cupertino.dart';

import '../api/news_api.dart';

class NewsBullet {
  String? title;
  String? description;
  DateTime? createdAt;

  NewsBullet({
    required this.title,
    required this.description,
    required this.createdAt,
  });

  NewsBullet.fromJSONMap(Map<String, dynamic> jsonMap) {
    this.title = jsonMap["title"];
    this.description = jsonMap["description"];
    this.createdAt = jsonMap["createdAt"];
  }
}

class NewsState extends ChangeNotifier {
  List<NewsBullet> _newsOnCurrentPage = [];
  int _currentPage = 0;
  int _totalPage = 0;
  List<NewsBullet> _news = [];

  LoginSession loginSession;
  NewsState({
    required this.loginSession,
  });

  setLoginSession(LoginSession loginSession) {
    this.loginSession = loginSession;
  }

  setCurrentPage({required int currentPage}) {
    _currentPage = currentPage;
    notifyListeners();
  }

  setNewsOnCurrentPage({required List<NewsBullet> newsOnCurrentPage}) {
    _newsOnCurrentPage = newsOnCurrentPage;
    notifyListeners();
  }

  setTotalPage({required int totalPage}) {
    _totalPage = totalPage;
    // notifyListeners();
  }

  String _getAccessToken() {
    var loginInfo = loginSession.info;
    if (loginInfo == null) {
      throw Exception('No access token');
    }

    return loginInfo.accessToken;
  }

  Future<void> fetchNews() async {
    // NewsBulletResponse response = await newsApi.fetchNewsBulletsAtPage(
    //   authToken: _getAccessToken(),
    // );

    // _news = [];
    // for (var i = 0; i < response.newsList.length; i++) {
    //   _news.add(NewsBullet.fromJSONMap(response.newsList[i]));
    // }
    String titleTemp =
        "รวมพลังกลุ่ม กฟผ. มอบเงิน 3 ล้านบาท จัดหายาฟ้าทะลายโจรช่วยผู้ป่วยโควิด-19";
    String descriptionTemp =
        "วันนี้ (13 สิงหาคม 2564) นายกิจจา ศรีพัฑฒางกุระ กรรมการผู้จัดการใหญ่ บริษัท ราช กรุ๊ป จำกัด (มหาชน) หรือ RATCH พร้อมด้วยนายเทพรัตน์ เทพพิทักษ์ กรรมการผู้จัดการใหญ่ บริษัท ผลิตไฟฟ้า จำกัด(มหาชน) หรือ EGCO และนายจรัญ คำเงิน ผู้ช่วยผู้ว่าการบริหารจัดการความยั่งยืน การไฟฟ้าฝ่ายผลิตแห่งประเทศไทย (กฟผ.) ร่วมพิธีมอบเงินให้แก่มูลนิธิยามเฝ้าแผ่นดินจำนวน 3 ล้านบาทเพื่อสมทบทุนในการจัดหายาฟ้าทะลายโจรให้แก่ผู้ป่วยโควิด -19 โดยมีนายปานเทพ พัวพงษ์พันธ์ รองประธานโครงการสนับสนุนการใช้ฟ้าทะลายโจรเพื่อช่วยประชาชนในช่วงโควิด-19 เป็นผู้แทนรับมอบผ่านระบบออนไลน์" +
            "นายกิจจา ศรีพัฑฒางกุระ กรรมการผู้จัดการใหญ่ RATCH ในฐานะผู้แทนกลุ่ม กฟผ. เปิดเผยว่า กลุ่ม กฟผ. พร้อมเป็นอีกหนึ่งภาคส่วนในการช่วยเหลือสนับสนุนหน่วยงานต่าง ๆ เพื่อบรรเทาผลกระทบจากการแพร่ระบาดของเชื้อโควิด-19 อย่างสุดกำลัง ตั้งแต่การจัดหาอุปกรณ์ทางการแพทย์ การผลิตนวัตกรรมทางการแพทย์ เตียงสนาม รวมถึงจัดหาอาหารและสิ่งของจำเป็นมอบให้แก่ประชาชน โดยในโอกาสนี้ กฟผ. RATCH และ EGCO ร่วมกันมอบเงินให้แก่มูลนิธิยามเฝ้าแผ่นดินจำนวน 3 ล้านบาท เพื่อสมทบทุนในการจัดหายาฟ้าทะลายโจรชนิดแคปซูล รวมถึงฟ้าทะลายโจรแบบต้นสดหรือต้นตากแห้งที่จะนำไปเป็นวัตถุดิบในการผลิตยาฟ้าทะลายโจรให้แก่ผู้ป่วยโควิด -19 สำหรับนำไปแจกจ่ายให้แก่ผู้ป่วยและคลัสเตอร์ที่มีการแพร่ระบาดของเชื้อโควิด-19 ในพื้นที่ต่าง ๆ เพื่อบรรเทาอาการระหว่างรอเข้ารับการรักษา และผ่านพ้นวิกฤตโควิด-19 ไปได้โดยเร็วที่สุด" +
            "ด้านนายปานเทพ พัวพงษ์พันธ์ รองประธานโครงการสนับสนุนการใช้ฟ้าทะลายโจรเพื่อช่วยประชาชนในช่วงโควิด-19 มูลนิธิยามเฝ้าแผ่นดิน กล่าวว่า มูลนิธิยามเฝ้าแผ่นดินได้ดำเนินการจัดหาฟ้าทะลายโจรชนิดแคปซูลฟ้าทะลายโจรแบบต้นสดและตากแห้ง รวมถึงวัตถุดิบในการผลิตขิงผงที่เป็นยาฤทธิ์ร้อนที่ใช้รับประทานคู่กับยาฟ้าทะลายโจรเพื่อลดอาการข้างเคียง มอบให้แก่ชุมชนแออัด วัด และโรงพยาบาลต่าง ๆ ในพื้นที่ที่มีการแพร่ระบาดของเชื้อโควิด-19 ทางมูลนิธิยามเฝ้าแผ่นดินรู้สึกยินดีเป็นอย่างยิ่งที่ได้ร่วมมือกับกลุ่ม กฟผ. ซึ่งเป็นองค์กรเสาหลักที่ช่วยเหลือสังคมมาในทุกวิกฤตมาอย่างต่อเนื่องและยาวนานนอกเหนือจากภารกิจด้านพลังงานไฟฟ้าทั้งในยามที่ประชาชนต้องการความช่วยเหลือการดูแลชุมชนสิ่งแวดล้อมซึ่งการสนับสนุนการจัดหายาฟ้าทะลายโจรในครั้งนี้ของกลุ่ม กฟผ. จะทำให้ยาฟ้าทะลายโจรเข้าถึงประชาชนที่ขาดโอกาสในการรักษาและผู้ป่วยโควิด-19 มากยิ่งขึ้น ตลอดจนช่วยลดความรุนแรงของการแพร่ระบาดของเชื้อโควิดให้อยู่ในวงจำกัดอีกด้วย";
    for (int i = 0; i < 22; i++) {
      NewsBullet bullet = NewsBullet(
          // title: "Title " + i.toString(),
          title: titleTemp + " " + i.toString(),
          // description: "description description description description description description description description\n description description description description description description description \n description description description description",
          description: descriptionTemp, //TODO:
          createdAt: DateTime.now());
      _news.add(bullet);
    }
    setTotalPage(totalPage: (_news.length / 4).ceil());
  }

  Future<void> fetchNewsAtPage(int page) async {
    if (page < 0) {
      throw Exception('Page cannot be less than 0');
    }
    if (page + 1 > _totalPage) {
      throw Exception('No more pages');
    }
    int startNewIndex = page * 4;
    int endNewIndex = (page + 1) * 4;
    if (((page + 1) * 4) > _news.length) {
      endNewIndex = _news.length;
    }
    // _newsOnCurrentPage = _news.sublist(startNewIndex, endNewIndex);
    setNewsOnCurrentPage(
        newsOnCurrentPage: _news.sublist(startNewIndex, endNewIndex));
    setCurrentPage(currentPage: page);
    // _currentPage = page;
    // notifyListeners();
    print("fetchNewsAtPage: " + _currentPage.toString());
    // _totalPage = response.totalPage;
  }

  Future<void> fetchNextPage() async {
    print("_currentPage: " + _currentPage.toString());
    print("_totalPage: " + _totalPage.toString());
    if (_currentPage + 1 > _totalPage) {
      throw Exception('No more pages');
    }

    await fetchNewsAtPage(_currentPage + 1);
  }

  Future<void> fetchPreviousPage() async {
    if (_currentPage - 1 < 0) {
      throw Exception('No previous pages');
    }

    await fetchNewsAtPage(_currentPage - 1);
  }

  Future<void> fetchCurrentPage() async {
    await fetchNewsAtPage(_currentPage);
  }

  Future<void> init() async {
    await fetchNews();
    await fetchNewsAtPage(0);
  }

  int get currentPage => _currentPage;
  int get totalPage => _totalPage;
  List<NewsBullet> get newsOnCurrentPage => _newsOnCurrentPage;
}
