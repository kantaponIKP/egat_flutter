// import 'dart:io' show Platform;
import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/i18n/app_localizations.dart';
import 'package:egat_flutter/screens/page/state/sidebar.dart';
import 'package:egat_flutter/screens/pages/main/states/main_screen_navigation_state.dart';
import 'package:egat_flutter/screens/pages/main/states/main_screen_title_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class NavigationMenuWidget extends StatefulWidget {
  const NavigationMenuWidget({Key? key}) : super(key: key);

  @override
  _NavigationMenuWidgetState createState() => _NavigationMenuWidgetState();
}

class UserInfoMockUp {
  final String firstName;
  final String lastName;
  final String email;

  const UserInfoMockUp(this.firstName, this.lastName, this.email);
}

class _NavigationMenuWidgetState extends State<NavigationMenuWidget> {
  final UserInfoMockUp _userInfo =
      new UserInfoMockUp('Logan1', 'venial', 'logan@gmail.com');

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Material(
            color: menuBgColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildMenu(context),
                _buildLogoutButton(context),
              ],
            )));
  }

  void onLogout(BuildContext context) {
    Color color = HexColor('#F6645A');
    const hoverColor = Colors.white70;

    // if (Platform.isIOS) {
    //   logger.d(Platform.operatingSystem);
    //   showIOSActionSheet(context);
    // } else {
    showAndriodActionSheet(context);
    // }
  }

  showAndriodActionSheet(BuildContext context) {
    Color color = HexColor('#F6645A');
    const hoverColor = Colors.white70;
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: <Widget>[
            SizedBox(
              height: 40,
              child: ListTile(
                title: Center(
                  child: Text(
                    'Are you sure you want to sign out ?',
                    style: TextStyle(
                      color: textButtonTheme,
                    ),
                  ),
                ),
                hoverColor: hoverColor,
              ),
            ),
            Divider(
              indent: 10,
              endIndent: 10,
              thickness: 1,
            ),
            ListTile(
                title: Center(
                  child: Text(
                    'Sign Out',
                    style: TextStyle(
                      color: color,
                    ),
                  ),
                ),
                hoverColor: hoverColor,
                onTap: () {
                  _onSignOutPressed();
                }),
            Divider(
              indent: 10,
              endIndent: 10,
              thickness: 1,
            ),
            ListTile(
                title: Center(
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: textButton,
                    ),
                  ),
                ),
                hoverColor: hoverColor,
                onTap: () {
                  logger.d('cancel button clicled');
                  Navigator.of(context).pop();
                }),
          ],
        );
      },
    );
  }

  showIOSActionSheet(BuildContext context) {
    return CupertinoActionSheet(
      actions: [
        CupertinoActionSheetAction(
          onPressed: () {
            logger.d('On CLick Logput');
          },
          child: Text(
            'Logout',
          ),
          isDestructiveAction: true,
        )
      ],
      cancelButton: CupertinoActionSheetAction(
        onPressed: () {},
        child: Text('Cancel'),
      ),
    );
  }

  _buildLogoutButton(BuildContext context) {
    Color color = HexColor('#F6645A');
    const hoverColor = Colors.white70;

    return Column(children: [
      Divider(
        color: HexColor('#FFFFFF'),
        thickness: 1,
        indent: 10,
        endIndent: 10,
      ),
      SizedBox(
        // height: 24,
        child: ListTile(
            leading: Icon(
              Icons.logout,
              color: color,
            ),
            title: Text(
              '${AppLocalizations.of(context).translate('sign-out')}',
              style: TextStyle(
                color: color,
              ),
            ),
            hoverColor: hoverColor,
            onTap: () {
              onLogout(context);
            }),
      ),
    ]);
  }

  _buildMenu(BuildContext context) {
    return Column(
      children: [
        _buildUserHeader(context, _userInfo),
        SizedBox(height: 16),
        _buildMenuItem(
          context: context,
          text: '${AppLocalizations.of(context).translate('home')}',
          icon: Icons.home,
          onAction: _onHomeMenuPressed,
        ),
        _buildMenuItem(
          context: context,
          text: '${AppLocalizations.of(context).translate('personal-info')}',
          icon: Icons.account_circle,
          onAction: _onPersonalInfoMenuPressed,
        ),
        _buildMenuItem(
          context: context,
          text: '${AppLocalizations.of(context).translate('change-password')}',
          icon: Icons.lock_sharp,
          onAction: _onChangePasswordMenuPressed,
        ),
        _buildMenuItem(
          context: context,
          text: '${AppLocalizations.of(context).translate('contact-us')}',
          icon: Icons.contact_page,
          onAction: _onContactUsMenuPressed,
        ),
        _buildMenuItem(
          context: context,
          text: '${AppLocalizations.of(context).translate('news')}',
          icon: Icons.campaign_sharp,
          onAction: _onNewsMenuPressed,
        ),
        _buildMenuItem(
          context: context,
          text: '${AppLocalizations.of(context).translate('setting')}',
          icon: Icons.settings,
          onAction: _onSettingMenuPressed,
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required String text,
    required IconData icon,
    required Function() onAction,
  }) {
    Color color = whiteColor;
    const hoverColor = Colors.white70;
    return SizedBox(
      // height: 24,
      child: Container(
        // color: Colors.black,
        child: ListTile(
            leading: Icon(
              icon,
              color: color,
            ),
            title: Text(
              text,
              style: TextStyle(
                color: color,
              ),
            ),
            hoverColor: hoverColor,
            onTap: () {
              onAction();
            }),
      ),
    );
  }

  Widget _buildUserHeader(BuildContext context, UserInfoMockUp userInfo) {
    return InkWell(
      child: Container(
        color: HexColor('#262729'),
        height: 80,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              // backgroundImage: ,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
              child: SizedBox(
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(userInfo.firstName + " " + userInfo.lastName),
                      Text(userInfo.email),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      onTap: () {},
    );
  }

  void _onChangePasswordMenuPressed() {
    MainScreenNavigationState mainScreenNavigation =
        Provider.of<MainScreenNavigationState>(context, listen: false);
    mainScreenNavigation.setPageToChangePassword();
    MainScreenTitleState mainScreenTitle =
        Provider.of<MainScreenTitleState>(context, listen: false);
    mainScreenTitle.setTitleTwoTitles(
        title: AppLocalizations.of(context)
            .translate('title-changePassword-first'),
        secondaryTitle: AppLocalizations.of(context)
            .translate('title-changePassword-second'));
  }

  void _onContactUsMenuPressed() {
    MainScreenNavigationState mainScreenNavigation =
        Provider.of<MainScreenNavigationState>(context, listen: false);
    mainScreenNavigation.setPageToContactUs();
    MainScreenTitleState mainScreenTitle =
        Provider.of<MainScreenTitleState>(context, listen: false);
    mainScreenTitle.setTitleTwoTitles(
        title: AppLocalizations.of(context)
            .translate('title-Contact-first'),
        secondaryTitle: AppLocalizations.of(context)
            .translate('title-Us-second'));
  }

  void _onHomeMenuPressed() {
    MainScreenNavigationState mainScreenNavigation =
        Provider.of<MainScreenNavigationState>(context, listen: false);
    mainScreenNavigation.setPageToHome();
        MainScreenTitleState mainScreenTitle =
        Provider.of<MainScreenTitleState>(context, listen: false);
    mainScreenTitle.setTitleLogo();
  }

  void _onNewsMenuPressed() {
    MainScreenNavigationState mainScreenNavigation =
        Provider.of<MainScreenNavigationState>(context, listen: false);
    mainScreenNavigation.setPageToNews();
        MainScreenTitleState mainScreenTitle =
        Provider.of<MainScreenTitleState>(context, listen: false);
    mainScreenTitle.setTitleOneTitle(title: AppLocalizations.of(context)
            .translate('title-news'));
  }

  void _onPersonalInfoMenuPressed() {
    MainScreenNavigationState mainScreenNavigation =
        Provider.of<MainScreenNavigationState>(context, listen: false);
    mainScreenNavigation.setPageToPersonalInfo();
    MainScreenTitleState mainScreenTitle =
        Provider.of<MainScreenTitleState>(context, listen: false);
    mainScreenTitle.setTitleTwoTitles(
        title: AppLocalizations.of(context)
            .translate('title-personalInformation-first'),
        secondaryTitle: AppLocalizations.of(context)
            .translate('title-personalInformation-second'));
  }

  void _onSettingMenuPressed() {
    MainScreenNavigationState mainScreenNavigation =
        Provider.of<MainScreenNavigationState>(context, listen: false);
    mainScreenNavigation.setPageToSetting();
        MainScreenTitleState mainScreenTitle =
        Provider.of<MainScreenTitleState>(context, listen: false);
    mainScreenTitle.setTitleOneTitle(title: AppLocalizations.of(context)
            .translate('title-setting'));
  }

  void _onSignOutPressed() {
    MainScreenNavigationState mainScreenNavigation =
        Provider.of<MainScreenNavigationState>(context, listen: false);
    mainScreenNavigation.setPageToSignOut();
  }
}

// class NavigationMenuWidget extends StatelessWidget {
//   const NavigationMenuWidget({Key? key}) : super(key: key);

// }

