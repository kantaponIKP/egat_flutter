import 'package:egat_flutter/i18n/app_localizations.dart';
import 'package:egat_flutter/screens/widgets/tabbar_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../states/buysell_navigation_state.dart';

class BuySellNavigationWidget extends StatelessWidget {
  

  BuySellNavigationWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final _tabBarItems = <TabBarNavigationItem<BuySellNavigationPage>>[
     TabBarNavigationItem(
      svgIcon: 'assets/images/icons/tabbar/forecast.svg',
      title: AppLocalizations.of(context).translate('trade-menu-forecast-top'),
      secondaryTitle: AppLocalizations.of(context).translate('trade-menu-forecast-bottom'),
      value: BuySellNavigationPage.FORECAST,
    ),
     TabBarNavigationItem(
      svgIcon: 'assets/images/icons/tabbar/bilateral.svg',
      title: AppLocalizations.of(context).translate('trade-menu-bilateral-top'),
      secondaryTitle: AppLocalizations.of(context).translate('trade-menu-bilateral-bottom'),
      value: BuySellNavigationPage.BILATERAL,
    ),
     TabBarNavigationItem(
      svgIcon: 'assets/images/icons/tabbar/poolMarket.svg',
      title: AppLocalizations.of(context).translate('trade-menu-poolMarket-top'),
      secondaryTitle: AppLocalizations.of(context).translate('trade-menu-poolMarket-bottom'),
      value: BuySellNavigationPage.POOL,
    ),
  ];

    final buySellNavigationState = Provider.of<BuySellNavigationState>(context);

    return TabBarNavigation<BuySellNavigationPage>(
      items: _tabBarItems,
      onTap: (value) => buySellNavigationState.setCurrentPage(value),
      value: buySellNavigationState.currentPage,
    );
  }
}
