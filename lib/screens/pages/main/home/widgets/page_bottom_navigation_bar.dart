import 'package:egat_flutter/i18n/app_localizations.dart';
import 'package:egat_flutter/screens/pages/main/home/states/home_screen_navigation.state.dart';
import 'package:egat_flutter/screens/pages/main/home/states/notification.state.dart';
import 'package:egat_flutter/screens/registration/api/model/LocationResponse.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:egat_flutter/constant.dart';

class _PageInfo {
  final String title;
  final String? svgIcon;
  final IconData? icon;
  final HomeScreenNavigationPage route;
  final int? unreadCount;

  const _PageInfo({
    required this.title,
    required this.route,
    this.svgIcon,
    this.icon,
    this.unreadCount,
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

  @override
  Widget build(BuildContext context) {
    final notificationState = Provider.of<NotificationState>(context);

    final List<_PageInfo> pageInfos = [
      const _PageInfo(
        title: 'home',
        icon: Icons.home,
        route: HomeScreenNavigationPage.MAIN,
      ),
      const _PageInfo(
        title: 'buy-sell',
        svgIcon: 'assets/images/icons/bottom_navigation_bar/buy_sell.svg',
        route: HomeScreenNavigationPage.BUYSELL,
      ),
      const _PageInfo(
        title: 'settlement',
        svgIcon: 'assets/images/icons/bottom_navigation_bar/settlement.svg',
        route: HomeScreenNavigationPage.SETTLEMENT,
      ),
      const _PageInfo(
        title: 'billing',
        svgIcon: 'assets/images/icons/bottom_navigation_bar/billing.svg',
        route: HomeScreenNavigationPage.BILLING,
      ),
      _PageInfo(
        title: 'notification',
        icon: Icons.notifications,
        route: HomeScreenNavigationPage.NOTIFICATION,
        unreadCount: notificationState.count,
      ),
    ];

    HomeScreenNavigationState homeScreenNavigationState =
        Provider.of<HomeScreenNavigationState>(context);

    var pageIndex = pageInfos.map((page) => page.route).toList().indexOf(
          homeScreenNavigationState.currentPage,
        );
    pageIndex = pageIndex == -1 ? 0 : pageIndex;

    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Colors.black,
      ),
      child: BottomNavigationBar(
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
      ),
    );
  }

  BottomNavigationBarItem _buildNavigationItem(
    MapEntry<int, _PageInfo> pageEntry,
    int pageIndex,
    BuildContext context,
  ) {
    final iconStackMember = [
      pageEntry.value.buildIcon(
        context,
        isSelected: pageIndex == pageEntry.key,
      ),
    ];

    final unreadCount = pageEntry.value.unreadCount;
    if (unreadCount != null && unreadCount > 0) {
      final String unreadCountString;

      if (unreadCount > 99) {
        unreadCountString = '99+';
      } else {
        unreadCountString = unreadCount.toString();
      }

      iconStackMember.add(
        Positioned(
          right: 0,
          top: 0,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              unreadCountString,
              style: TextStyle(
                color: whiteColor,
                fontSize: 10,
              ),
            ),
          ),
        ),
      );
    }

    return BottomNavigationBarItem(
      icon: Stack(
        children: iconStackMember,
      ),
      label: '${AppLocalizations.of(context).translate(pageEntry.value.title)}',
    );
  }
}
