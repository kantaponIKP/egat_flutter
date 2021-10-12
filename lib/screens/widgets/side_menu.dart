import 'dart:io' show Platform;

import 'package:egat_flutter/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class NavigationMenuWidget extends StatelessWidget {
  const NavigationMenuWidget({Key? key}) : super(key: key);

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

  _buildMenu(BuildContext context) {
    return Column(
      children: [
        _buildUserHeader(context),
        _buildMenuItem(
          context: context,
          text: 'Home',
          icon: Icons.home,
          destination: 'home',
        ),
        _buildMenuItem(
            context: context,
            text: 'Personal Information',
            icon: Icons.account_circle,
            destination: 'personal_information'),
        _buildMenuItem(
            context: context,
            text: 'Change Password',
            icon: Icons.lock_sharp,
            destination: 'change_password'),
        _buildMenuItem(
            context: context,
            text: 'Contact Us',
            icon: Icons.contact_page,
            destination: 'contact_us'),
        _buildMenuItem(
            context: context,
            text: 'News',
            icon: Icons.campaign_sharp,
            destination: 'home'),
        _buildMenuItem(
            context: context,
            text: 'Setting',
            icon: Icons.settings,
            destination: 'home'),
        // _buildLogoutButton(context)
      ],
    );
  }

  Widget _buildUserHeader(BuildContext context) {
    return InkWell(
      child: Container(
        height: 80,
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Placeholder(),
          ],
        ),
      ),
      onTap: () {},
    );
  }

  Widget _buildMenuItem(
      {required BuildContext context,
      required String text,
      required IconData icon,
      required String destination}) {
    Color color = white;
    const hoverColor = Colors.white70;
    return SizedBox(
      // height: 24,
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
            logger.d('redirected to : $destination');
            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (BuildContext context) {
            //       // return ;
            //     },
            //   ),
            // );
          }),
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
              'Logout',
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
            ListTile(
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
                onTap: () {}),
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
}
