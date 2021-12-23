import 'package:egat_flutter/screens/page/widgets/page_appbar.dart';
import 'package:egat_flutter/screens/pages/main/home/home_page.dart';
import 'package:egat_flutter/screens/pages/main/states/main_screen_title_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'states/main_screen_navigation_state.dart';
import 'widgets/logo_appbar.dart';
import 'widgets/navigation_menu_widget.dart';

class _AppBar extends StatelessWidget with PreferredSizeWidget {
  const _AppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final titleState = Provider.of<MainScreenTitleState>(context);
    PreferredSizeWidget title = const LogoAppbar();
    switch (titleState.type) {
      case MainScreenTitleType.LOGO:
        title = const LogoAppbar();
        break;
      case MainScreenTitleType.ONE_TITLE:
        title = PageAppbar(firstTitle: titleState.titles[0], secondTitle: "");
        break;
      case MainScreenTitleType.TWO_TITLE:
        title = PageAppbar(
          firstTitle: titleState.titles[0],
          secondTitle: titleState.titles[1],
        );
        break;
    }
    return title;
  }
}

class _AppBody extends StatelessWidget {
  const _AppBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final navigationState = Provider.of<MainScreenNavigationState>(context);

    Widget widget = Container();

    var duration = Duration(microseconds: 150);

    switch (navigationState.currentPage) {
      case MainScreenNavigationPage.HOME:
        widget = HomePage(key: Key('home'));
        break;
      default:
        widget = Container(key: Key('blank'));
    }

    return AnimatedSwitcher(
      duration: duration,
      child: widget,
      transitionBuilder: buildSlideTransition,
    );
  }

  Widget buildSlideTransition(Widget child, Animation<double> animation) {
    const begin = Offset(1.0, 0.0);
    const end = Offset.zero;
    const curve = Curves.ease;

    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

    return SlideTransition(
      position: animation.drive(tween),
      child: child,
    );
  }
}

class MainScreen extends StatelessWidget {
  MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildContent(context);
  }

  Widget _buildContent(BuildContext context) {
    return Scaffold(
      appBar: _AppBar(),
      drawer: NavigationMenuWidget(),
      body: SafeArea(child: _AppBody()),
    );
  }
}
