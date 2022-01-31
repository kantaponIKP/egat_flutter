import 'package:egat_flutter/i18n/app_localizations.dart';
import 'package:egat_flutter/screens/widgets/tabbar_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../states/settlement_navigation_state.dart';

class SettlementNavigationWidget extends StatefulWidget {
  const SettlementNavigationWidget({Key? key}) : super(key: key);

  @override
  State<SettlementNavigationWidget> createState() =>
      _SettlementNavigationWidgetState();
}

class _SettlementNavigationWidgetState
    extends State<SettlementNavigationWidget> {
  @override
  Widget build(BuildContext context) {
    print(AppLocalizations.of(context).getLocale().toString());
    final _tabBarItems = <TabBarNavigationItem<SettlementNavigationPage>>[
      TabBarNavigationItem(
        svgIcon: 'assets/images/icons/tabbar/forecast.svg',
        title: AppLocalizations.of(context).translate('settlement-menu-order'),
        value: SettlementNavigationPage.ORDER,
      ),
      TabBarNavigationItem(
        svgIcon: 'assets/images/icons/tabbar/bilateral.svg',
        title: AppLocalizations.of(context)
            .translate('settlement-menu-energyTransfer'),
        value: SettlementNavigationPage.ENERGY_TRANSFER,
      ),
      (AppLocalizations.of(context).getLocale().toString() != 'th')
          ? TabBarNavigationItem(
              svgIcon: 'assets/images/icons/tabbar/poolMarket.svg',
              title: AppLocalizations.of(context)
                  .translate('settlement-menu-SettlementReport-first'),
              secondaryTitle: AppLocalizations.of(context)
                  .translate('settlement-menu-SettlementReport-second'),
              value: SettlementNavigationPage.SETTLEMENT_REPORT,
            )
          : TabBarNavigationItem(
              svgIcon: 'assets/images/icons/tabbar/poolMarket.svg',
              title: AppLocalizations.of(context)
                  .translate('settlement-menu-SettlementReport-first'),
              value: SettlementNavigationPage.SETTLEMENT_REPORT,
            ),
    ];

    final buySellNavigationState =
        Provider.of<SettlementNavigationState>(context);

    return TabBarNavigation<SettlementNavigationPage>(
      items: _tabBarItems,
      onTap: (value) => buySellNavigationState.setCurrentPage(value),
      value: buySellNavigationState.currentPage,
    );
  }
}
