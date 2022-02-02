// import 'dart:io' show Platform;
import 'dart:convert';
import 'dart:io';

import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/i18n/app_localizations.dart';
import 'package:egat_flutter/screens/login/state/login_model.dart';
import 'package:egat_flutter/screens/pages/main/states/main_screen_navigation_state.dart';
import 'package:egat_flutter/screens/pages/main/states/main_screen_title_state.dart';
import 'package:egat_flutter/screens/pages/main/states/personal_info_state.dart';
import 'package:egat_flutter/screens/widgets/loading_dialog.dart';
import 'package:egat_flutter/screens/widgets/show_exception.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class NavigationMenuWidget extends StatefulWidget {
  const NavigationMenuWidget({Key? key}) : super(key: key);

  @override
  _NavigationMenuWidgetState createState() => _NavigationMenuWidgetState();
}

class UserInfo {
  final String username;
  final String email;

  const UserInfo(this.username, this.email);
}

class _NavigationMenuWidgetState extends State<NavigationMenuWidget> {
  String? _username;
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
        ),
      ),
    );
  }

  void onSignout(BuildContext context) {
    if (Platform.isIOS) {
      logger.d(Platform.operatingSystem);
      showIOSActionSheet(context);
    } else {
      showAndriodActionSheet(context);
    }
  }

  showAndriodActionSheet(BuildContext context) {
    return showModalBottomSheet(
        backgroundColor: whiteColor,
        context: context,
        builder: buildAndroidActionSheet);
  }

  Widget buildAndroidActionSheet(BuildContext context) {
    const hoverColor = Colors.white70;
    return Wrap(
      children: <Widget>[
        SizedBox(
          height: 40,
          child: ListTile(
            title: Center(
              child: Text(
                AppLocalizations.of(context).translate('message-signout-title'),
                style: TextStyle(
                  color: textButtonTheme,
                ),
              ),
            ),
            hoverColor: hoverColor,
          ),
        ),
        Divider(
          color: greyColor,
          indent: 10,
          endIndent: 10,
          thickness: 1,
        ),
        ListTile(
            title: Center(
              child: Text(
                AppLocalizations.of(context)
                    .translate('message-signout-signout'),
                style: TextStyle(
                  color: redColor,
                ),
              ),
            ),
            hoverColor: hoverColor,
            onTap: () {
              _onSignOutPressed();
            }),
        Divider(
          color: greyColor,
          indent: 10,
          endIndent: 10,
          thickness: 1,
        ),
        ListTile(
            title: Center(
              child: Text(
                AppLocalizations.of(context).translate('cancel'),
                style: TextStyle(
                  color: textButtonTheme,
                ),
              ),
            ),
            hoverColor: hoverColor,
            onTap: () {
              Navigator.of(context).pop();
            }),
      ],
    );
  }

  showIOSActionSheet(BuildContext context) {
    return showCupertinoModalPopup(
        context: context, builder: buildIOSActionSheet);
  }

  Widget buildIOSActionSheet(BuildContext context) {
    return CupertinoActionSheet(
      message: Text(
        AppLocalizations.of(context).translate('message-signout-title'),
      ),
      actions: [
        CupertinoActionSheetAction(
          onPressed: () {
            _onSignOutPressed();
          },
          child: Text(
            AppLocalizations.of(context).translate('message-signout-signout'),
          ),
          isDestructiveAction: true,
        )
      ],
      cancelButton: CupertinoActionSheetAction(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text(AppLocalizations.of(context).translate('cancel')),
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
              onSignout(context);
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
          icon: SvgPicture.asset('assets/images/icons/sidebar/home_icon.svg'),
          onAction: _onHomeMenuPressed,
          page: MainScreenNavigationPage.HOME,
        ),
        _buildMenuItem(
          context: context,
          text: '${AppLocalizations.of(context).translate('personal-info')}',
          icon: SvgPicture.asset(
              'assets/images/icons/sidebar/personal_info_icon.svg'),
          onAction: _onPersonalInfoMenuPressed,
          page: MainScreenNavigationPage.PERSONAL_INFORMATION,
        ),
        _buildMenuItem(
          context: context,
          text: '${AppLocalizations.of(context).translate('change-password')}',
          icon: SvgPicture.asset(
              'assets/images/icons/sidebar/change_password_icon.svg'),
          onAction: _onChangePasswordMenuPressed,
          page: MainScreenNavigationPage.CHANGE_PASSWORD,
        ),
        _buildMenuItem(
          context: context,
          text: '${AppLocalizations.of(context).translate('contact-us')}',
          icon:
              SvgPicture.asset('assets/images/icons/sidebar/contact_icon.svg'),
          onAction: _onContactUsMenuPressed,
          page: MainScreenNavigationPage.CONTACT_US,
        ),
        _buildMenuItem(
          context: context,
          text: '${AppLocalizations.of(context).translate('news')}',
          icon: SvgPicture.asset('assets/images/icons/sidebar/news_icon.svg'),
          onAction: _onNewsMenuPressed,
          page: MainScreenNavigationPage.NEWS,
        ),
        _buildMenuItem(
          context: context,
          text: '${AppLocalizations.of(context).translate('setting')}',
          icon:
              SvgPicture.asset('assets/images/icons/sidebar/setting_icon.svg'),
          onAction: _onSettingMenuPressed,
          page: MainScreenNavigationPage.SETTING,
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required String text,
    required Widget icon,
    required Function() onAction,
    required MainScreenNavigationPage page,
  }) {
    var model = Provider.of<MainScreenNavigationState>(context, listen: false);
    Color color = whiteColor;
    const hoverColor = Colors.white70;
    return SizedBox(
      child: Container(
        decoration: BoxDecoration(
            border: Border(
          left: BorderSide(
              width: 8.0,
              color: (model.currentPage == page)
                  ? primaryColor
                  : surfaceGreyColor),
        )),
        child: ListTile(
            tileColor:
                (model.currentPage == page) ? contentBgColor : surfaceGreyColor,
            leading: icon,
            // color: color,
            // ),
            title: Text(
              text,
              style: TextStyle(
                fontSize: 16,
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
          child: ClipOval(
            child: Image.memory(
              base64Decode(_imageBase64!),
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
        );
      }
    } catch (e) {
      return CircleAvatar();
    }
  }

  Widget _buildUserHeader(BuildContext context, UserInfo userInfo) {
    return InkWell(
      child: Container(
        color: contentBgColor,
        height: 120,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Padding(
          padding: const EdgeInsets.only(top: 30),
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
                        Text(userInfo.username, style: TextStyle(fontSize: 20)),
                        Text(userInfo.email),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      onTap: () {},
    );
  }

  void _getPersonalInformation() async {
    var model = Provider.of<PersonalInfoState>(context, listen: false);
    if (model.info.username == null) {
      try {
        await showLoading();
        await model.getPersonalInformation();
      } catch (e) {
        showIntlException(context, e);
      } finally {
        await hideLoading();
      }
    }

    if (model.info.username != null) {
      setState(() {
        _username = model.info.username!;
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

    if (_username != null && _email != null) {
      setState(() {
        _userInfo = new UserInfo(_username!, _email!);
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
    // MainScreenTitleState mainScreenTitle =
    //     Provider.of<MainScreenTitleState>(context, listen: false);
    // mainScreenTitle.setTitleOneTitle(
    //     title: AppLocalizations.of(context).translate('title-setting'));
    Navigator.pop(context);
  }

  Future<void> _onSignOutPressed() async {
    MainScreenNavigationState mainScreenNavigation =
        Provider.of<MainScreenNavigationState>(context, listen: false);
    LoginModel loginModel = Provider.of<LoginModel>(context, listen: false);
    try {
      await showLoading();
      await loginModel.processLogout();
      mainScreenNavigation.setPageToSignOut();
    } catch (e) {
      print(e);
      showIntlException(context, e);
    } finally {
      await hideLoading();
    }
  }
}

// class NavigationMenuWidget extends StatelessWidget {
//   const NavigationMenuWidget({Key? key}) : super(key: key);

// }

