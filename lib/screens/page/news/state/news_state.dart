import 'package:egat_flutter/screens/session.dart';
import 'package:flutter/cupertino.dart';

import '../api/news_api.dart';

class NewsState extends ChangeNotifier {
  List<NewsBullet> _newsOnCurrentPage = [];
  int _currentPage = 0;
  int _totalPage = 0;

  LoginSession loginSession;
  NewsState({
    required this.loginSession,
  });

  setLoginSession(LoginSession loginSession) {
    this.loginSession = loginSession;
  }

  String _getAccessToken() {
    var loginInfo = loginSession.info;
    if (loginInfo == null) {
      throw Exception('No access token');
    }

    return loginInfo.accessToken;
  }

  Future<void> fetchNewsAtPage(int page) async {
    if (page < 0) {
      throw Exception('Page cannot be less than 0');
    }

    var response = await newsApi.fetchNewsBulletsAtPage(
      page: page,
      authToken: _getAccessToken(),
    );

    _newsOnCurrentPage = response.newsBullets;
    _currentPage = page;
    _totalPage = response.totalPage;
    notifyListeners();
  }

  Future<void> fetchNextPage() async {
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
    await fetchNewsAtPage(0);
  }

  int get currentPage => _currentPage;
  int get totalPage => _totalPage;
  List<NewsBullet> get newsOnCurrentPage => _newsOnCurrentPage;
}
