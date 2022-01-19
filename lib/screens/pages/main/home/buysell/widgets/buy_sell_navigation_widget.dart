import 'package:egat_flutter/screens/widgets/tabbar_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../states/buysell_navigation_state.dart';

class BuySellNavigationWidget extends StatelessWidget {
  final _tabBarItems = const <TabBarNavigationItem<BuySellNavigationPage>>[
    const TabBarNavigationItem(
      svgIcon: 'assets/images/icons/tabbar/forecast.svg',
      title: 'Forecast',
      value: BuySellNavigationPage.FORECAST,
    ),
    const TabBarNavigationItem(
      svgIcon: 'assets/images/icons/tabbar/bilateral.svg',
      title: 'Bilateral',
      secondaryTitle: 'Trade',
      value: BuySellNavigationPage.BILATERAL,
    ),
    const TabBarNavigationItem(
      svgIcon: 'assets/images/icons/tabbar/poolMarket.svg',
      title: 'Pool',
      secondaryTitle: 'Market',
      value: BuySellNavigationPage.POOL,
    ),
  ];

  const BuySellNavigationWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buySellNavigationState = Provider.of<BuySellNavigationState>(context);

    return TabBarNavigation<BuySellNavigationPage>(
      items: _tabBarItems,
      onTap: (value) => buySellNavigationState.setCurrentPage(value),
      value: buySellNavigationState.currentPage,
    );
  }
}
