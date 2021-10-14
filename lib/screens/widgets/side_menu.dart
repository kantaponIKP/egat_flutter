// import 'dart:io' show Platform;
import 'package:egat_flutter/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class NavigationMenuWidget extends StatefulWidget {
  const NavigationMenuWidget({Key? key}) : super(key: key);

  @override
  _NavigationMenuWidgetState createState() => _NavigationMenuWidgetState();
}

class UserInfoMockUp {
  final String firstName;
  final String lastName;
  final String email;

  const UserInfoMockUp(this.firstName,this.lastName,this.email);
}

class _NavigationMenuWidgetState extends State<NavigationMenuWidget> {
  final UserInfoMockUp _userInfo = new UserInfoMockUp('Firstname','Lastname','email@email.com');
  
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
        _buildUserHeader(context,_userInfo),
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

  Widget _buildUserHeader(BuildContext context,UserInfoMockUp userInfo) {
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

// class NavigationMenuWidget extends StatelessWidget {
//   const NavigationMenuWidget({Key? key}) : super(key: key);

// }
