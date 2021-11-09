import 'package:egat_flutter/i18n/app_localizations.dart';
import 'package:egat_flutter/screens/page/state/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:egat_flutter/constant.dart';

class PageBottomNavigationBar extends StatelessWidget {
  final int index;

  const PageBottomNavigationBar({Key? key, this.index = 0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BottomNavigationBarPage model =
            Provider.of<BottomNavigationBarPage>(context, listen: false);
    return BottomNavigationBar(
      onTap: (int index) {
        
        if (index == 0) {
          model.setPageHome();
        } else if (index == 1) {
          model.setPageTrade();
        }
      },
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedFontSize: 10,
      selectedFontSize: 12,
      type: BottomNavigationBarType.fixed,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '${AppLocalizations.of(context).translate('home')}',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/images/icons/bottom_navigation_bar/buy_sell.svg',
            fit: BoxFit.contain,
            height: 20,
            color: (model.info.index == 1)? Theme.of(context).primaryColor: whiteColor
          ),
          label: '${AppLocalizations.of(context).translate('buy-sell')}',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/images/icons/bottom_navigation_bar/settlement.svg',
            fit: BoxFit.contain,
            height: 20,
            color: (model.info.index == 2)? Theme.of(context).primaryColor: whiteColor
          ),
          label: '${AppLocalizations.of(context).translate('settlement')}',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/images/icons/bottom_navigation_bar/billing.svg',
            fit: BoxFit.contain,
            height: 20,
            color: (model.info.index == 3)? Theme.of(context).primaryColor: whiteColor
          ),
          label: '${AppLocalizations.of(context).translate('billing')}',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: '${AppLocalizations.of(context).translate('notification')}',
          
        ),
      ],
      // currentIndex: _selectedIndex,
      currentIndex: model.info.index!,
      // selectedItemColor: Theme.of(context).primaryColor,
      // onTap: _onItemTapped,
    );
  }
}
