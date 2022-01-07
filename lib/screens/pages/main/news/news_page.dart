import 'package:egat_flutter/screens/pages/main/news/news_screen.dart';
import 'package:egat_flutter/screens/pages/main/news/state/news_state.dart';
import 'package:egat_flutter/screens/session.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<LoginSession, NewsState>(
      create: (context) {
        var loginSession = Provider.of<LoginSession>(context, listen: false);
        return NewsState(loginSession: loginSession);
      },
      update: (context, LoginSession value, NewsState? previous) {
        if (previous == null) {
          return NewsState(loginSession: value);
        } else {
          previous.setLoginSession(value);
          return previous;
        }
      },
      child: NewsScreen(),
    );
  }
}
