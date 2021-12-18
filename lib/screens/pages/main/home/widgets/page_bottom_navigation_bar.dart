import 'dart:collection';

import 'package:egat_flutter/i18n/app_localizations.dart';
import 'package:egat_flutter/screens/pages/main/home/states/home_screen_navigation.state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:egat_flutter/constant.dart';

class _PageInfo {
  final String title;
  final String? svgIcon;
  final IconData? icon;
  final HomeScreenNavigationPage route;

  const _PageInfo({
    required this.title,
    required this.route,
    this.svgIcon,
    this.icon,
  });

  Widget buildIcon(
    BuildContext context, {
    bool isSelected = false,
  }) {
    if (svgIcon != null) {
      return SvgPicture.asset(
        svgIcon!,
        fit: BoxFit.contain,
        height: 20,
        color: isSelected ? Theme.of(context).primaryColor : whiteColor,
      );
    }

    if (icon != null) {
      return Icon(
        icon,
        color: isSelected ? Theme.of(context).primaryColor : whiteColor,
      );
    }

    throw new Exception('Icon and svgIcon is null');
  }

  bool operator ==(Object a) {
    if (a is _PageInfo) {
      return a.route == route;
    }

    return false;
  }

  @override
  int get hashCode => route.hashCode;
}

class PageBottomNavigationBar extends StatelessWidget {
  final int index;

  const PageBottomNavigationBar({Key? key, this.index = 0}) : super(key: key);

  final List<_PageInfo> pageInfos = const [
    const _PageInfo(
      title: 'home',
      icon: Icons.home,
      route: HomeScreenNavigationPage.MAIN,
    ),
    _PageInfo(
      title: 'buy-sell',
      svgIcon: 'assets/images/icons/bottom_navigation_bar/buy_sell.svg',
      route: HomeScreenNavigationPage.BUYSELL,
    ),
    _PageInfo(
      title: 'settlement',
      svgIcon: 'assets/images/icons/bottom_navigation_bar/settlement.svg',
      route: HomeScreenNavigationPage.SETTLEMENT,
    ),
    _PageInfo(
      title: 'billing',
      svgIcon: 'assets/images/icons/bottom_navigation_bar/billing.svg',
      route: HomeScreenNavigationPage.BILLING,
    ),
    _PageInfo(
      title: 'notification',
      icon: Icons.notifications,
      route: HomeScreenNavigationPage.NOTIFICATION,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    HomeScreenNavigationState homeScreenNavigationState =
        Provider.of<HomeScreenNavigationState>(context);

    Map<HomeScreenNavigationPage, _PageInfo> pageInfoRouteMapped =
        _getPageRouteMapped();
    int pageIndex = _getPageIndex(homeScreenNavigationState);

    return BottomNavigationBar(
      onTap: (int index) {
        if (index < 0 || index >= pageInfos.length) {
          return;
        }

        final nextPage = pageInfos[index].route;
        homeScreenNavigationState.setCurrentPage(nextPage);
      },
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedFontSize: 10,
      selectedFontSize: 12,
      type: BottomNavigationBarType.fixed,
      items: <BottomNavigationBarItem>[
        for (var pageEntry in pageInfos.asMap().entries)
          _buildNavigationItem(pageEntry, pageIndex, context),
      ],
      currentIndex: pageIndex,
    );
  }

  BottomNavigationBarItem _buildNavigationItem(
    MapEntry<int, _PageInfo> pageEntry,
    int pageIndex,
    BuildContext context,
  ) {
    return BottomNavigationBarItem(
      icon: pageEntry.value.buildIcon(
        context,
        isSelected: pageIndex == pageEntry.key,
      ),
      label: '${AppLocalizations.of(context).translate(pageEntry.value.title)}',
    );
  }

  Map<HomeScreenNavigationPage, _PageInfo> _getPageRouteMapped() {
    var pageInfoRouteMapped =
        Map<HomeScreenNavigationPage, _PageInfo>.fromIterable(pageInfos,
            key: (pageInfo) => (pageInfo as _PageInfo).route,
            value: (pageInfo) => pageInfo);
    return pageInfoRouteMapped;
  }

  int _getPageIndex(HomeScreenNavigationState homeScreenNavigationState) {
    var pageIndex = pageInfos.map((page) => page.route).toList().indexOf(
          homeScreenNavigationState.currentPage,
        );
    pageIndex = pageIndex == -1 ? 0 : pageIndex;
    return pageIndex;
  }
}
