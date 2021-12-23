import 'package:egat_flutter/screens/widgets/tabbar_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../states/settlement_navigation_state.dart';

class SettlementNavigationWidget extends StatelessWidget {
  final _tabBarItems = const <TabBarNavigationItem<SettlementNavigationPage>>[
    const TabBarNavigationItem(
      icon: Icons.home,
      title: 'Order',
      value: SettlementNavigationPage.ORDER,
    ),
    const TabBarNavigationItem(
      icon: Icons.handyman,
      title: 'Energy Transfer',
      value: SettlementNavigationPage.ENERGY_TRANSFER,
    ),
    const TabBarNavigationItem(
      icon: Icons.refresh,
      title: 'Settlement',
      secondaryTitle: 'Report',
      value: SettlementNavigationPage.SETTLEMENT_REPORT,
    ),
  ];

  const SettlementNavigationWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buySellNavigationState =
        Provider.of<SettlementNavigationState>(context);

    return TabBarNavigation<SettlementNavigationPage>(
      items: _tabBarItems,
      onTap: (value) => buySellNavigationState.setCurrentPage(value),
      value: buySellNavigationState.currentPage,
    );
  }
}
