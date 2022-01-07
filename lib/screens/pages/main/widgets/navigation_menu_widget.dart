// import 'dart:io' show Platform;
import 'dart:convert';

import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/i18n/app_localizations.dart';
import 'package:egat_flutter/screens/pages/main/states/main_screen_navigation_state.dart';
import 'package:egat_flutter/screens/pages/main/states/main_screen_title_state.dart';
import 'package:egat_flutter/screens/pages/main/states/personal_info_state.dart';
import 'package:egat_flutter/screens/widgets/loading_dialog.dart';
import 'package:egat_flutter/screens/widgets/show_exception.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class NavigationMenuWidget extends StatefulWidget {
  const NavigationMenuWidget({Key? key}) : super(key: key);

  @override
  _NavigationMenuWidgetState createState() => _NavigationMenuWidgetState();
}

class UserInfo {
  final String fullName;
  final String email;

  const UserInfo(this.fullName, this.email);
}

class _NavigationMenuWidgetState extends State<NavigationMenuWidget> {
  String? _fullName;
  String? _email;
  String? _imageBase64;

  UserInfo _userInfo = new UserInfo('', '');

  @override
  void initState() {
    super.initState();

    _getPersonalInformation();
  }

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
          page: MainScreenNavigationPage.HOME,
        ),
        _buildMenuItem(
          context: context,
          text: '${AppLocalizations.of(context).translate('personal-info')}',
          icon: Icons.account_circle,
          onAction: _onPersonalInfoMenuPressed,
          page: MainScreenNavigationPage.PERSONAL_INFORMATION,
        ),
        _buildMenuItem(
          context: context,
          text: '${AppLocalizations.of(context).translate('change-password')}',
          icon: Icons.lock_sharp,
          onAction: _onChangePasswordMenuPressed,
          page: MainScreenNavigationPage.CHANGE_PASSWORD,
        ),
        _buildMenuItem(
          context: context,
          text: '${AppLocalizations.of(context).translate('contact-us')}',
          icon: Icons.contact_page,
          onAction: _onContactUsMenuPressed,
          page: MainScreenNavigationPage.CONTACT_US,
        ),
        _buildMenuItem(
          context: context,
          text: '${AppLocalizations.of(context).translate('news')}',
          icon: Icons.campaign_sharp,
          onAction: _onNewsMenuPressed,
          page: MainScreenNavigationPage.NEWS,
        ),
        _buildMenuItem(
          context: context,
          text: '${AppLocalizations.of(context).translate('setting')}',
          icon: Icons.settings,
          onAction: _onSettingMenuPressed,
          page: MainScreenNavigationPage.SETTING,
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required String text,
    required IconData icon,
    required Function() onAction,
    required MainScreenNavigationPage page,
  }) {
    var model = Provider.of<MainScreenNavigationState>(context, listen: false);
    Color color = whiteColor;
    const hoverColor = Colors.white70;
    return SizedBox(
      // height: 24,
      child: Container(
        // color: Colors.black,
        child: ListTile(
            tileColor: (model.currentPage == page) ? contentBgColor : surfaceGreyColor, 
            leading: Icon(
              icon,
              color: color,
            ),
            title: Text(
              text,
              style: TextStyle(
                color: (model.currentPage == page) ? primaryColor : color,
              ),
            ),
            hoverColor: hoverColor,
            onTap: () {
              onAction();
            }),
      ),
    );
  }

  Widget _buildAvatar() {
    try {
      if (_imageBase64 == null || _imageBase64 == "") {
        return CircleAvatar(
          radius: 30,
        );
      } else {
        return CircleAvatar(
            radius: 30,
            child: ClipOval(child: Image.memory(base64Decode(_imageBase64!))));
      }
    } catch (e) {
      return CircleAvatar();
    }
  }

  Widget _buildUserHeader(BuildContext context, UserInfo userInfo) {
    return InkWell(
      child: Container(
        color: contentBgColor,
        height: 80,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Row(
          children: [
            _buildAvatar(),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
              child: SizedBox(
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(userInfo.fullName),
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

  void _getPersonalInformation() async {
    var model = Provider.of<PersonalInfoState>(context, listen: false);
    print(model.info.fullName);
    if (model.info.fullName == null) {
      try {
        await showLoading();
        await model.getPersonalInformation();
      } catch (e) {
        showIntlException(context, e);
      } finally {
        await hideLoading();
      }
    }

    if (model.info.fullName != null) {
      setState(() {
        _fullName = model.info.fullName!;
      });
    }
    if (model.info.email != null) {
      setState(() {
        _email = model.info.email!;
      });
    }
    if (model.info.photo != null) {
      setState(() {
        _imageBase64 = model.info.photo!;
      });
    }

    if (_fullName != null && _email != null) {
      setState(() {
        _userInfo = new UserInfo(_fullName!, _email!);
      });
    }
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
    Navigator.pop(context);
  }

  void _onContactUsMenuPressed() {
    MainScreenNavigationState mainScreenNavigation =
        Provider.of<MainScreenNavigationState>(context, listen: false);
    mainScreenNavigation.setPageToContactUs();
    MainScreenTitleState mainScreenTitle =
        Provider.of<MainScreenTitleState>(context, listen: false);
    mainScreenTitle.setTitleTwoTitles(
        title: AppLocalizations.of(context).translate('title-contactUs-first'),
        secondaryTitle:
            AppLocalizations.of(context).translate('title-contactUs-second'));
    Navigator.pop(context);
  }

  void _onHomeMenuPressed() {
    MainScreenNavigationState mainScreenNavigation =
        Provider.of<MainScreenNavigationState>(context, listen: false);
    mainScreenNavigation.setPageToHome();
    MainScreenTitleState mainScreenTitle =
        Provider.of<MainScreenTitleState>(context, listen: false);
    mainScreenTitle.setTitleLogo();
    Navigator.pop(context);
  }

  void _onNewsMenuPressed() {
    MainScreenNavigationState mainScreenNavigation =
        Provider.of<MainScreenNavigationState>(context, listen: false);
    mainScreenNavigation.setPageToNews();
    MainScreenTitleState mainScreenTitle =
        Provider.of<MainScreenTitleState>(context, listen: false);
    mainScreenTitle.setTitleOneTitle(
        title: AppLocalizations.of(context).translate('title-news'));
    Navigator.pop(context);
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
    Navigator.pop(context);
  }

  void _onSettingMenuPressed() {
    MainScreenNavigationState mainScreenNavigation =
        Provider.of<MainScreenNavigationState>(context, listen: false);
    mainScreenNavigation.setPageToSetting();
    MainScreenTitleState mainScreenTitle =
        Provider.of<MainScreenTitleState>(context, listen: false);
    mainScreenTitle.setTitleOneTitle(
        title: AppLocalizations.of(context).translate('title-setting'));
    Navigator.pop(context);
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

