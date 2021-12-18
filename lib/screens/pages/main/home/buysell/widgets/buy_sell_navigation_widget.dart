import 'package:egat_flutter/screens/widgets/tabbar_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../states/buysell_navigation_state.dart';

class BuySellNavigationWidget extends StatelessWidget {
  final _tabBarItems = const <TabBarNavigationItem<BuySellNavigationPage>>[
    const TabBarNavigationItem(
      icon: Icons.home,
      title: 'Forecast',
      value: BuySellNavigationPage.FORECAST,
    ),
    const TabBarNavigationItem(
      icon: Icons.handyman,
      title: 'Bilateral',
      secondaryTitle: 'Trade',
      value: BuySellNavigationPage.BILATERAL,
    ),
    const TabBarNavigationItem(
      icon: Icons.refresh,
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
