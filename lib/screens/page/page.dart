import 'package:egat_flutter/screens/page/page_model.dart';
import 'package:egat_flutter/screens/page/state/bottom_navigation_bar.dart';
import 'package:egat_flutter/screens/page/state/change_password.dart';
import 'package:egat_flutter/screens/page/state/home.dart';
import 'package:egat_flutter/screens/page/state/page_status.dart';
import 'package:egat_flutter/screens/page/state/personal_info.dart';
import 'package:egat_flutter/screens/page/state/sidebar.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'page_screen.dart';

class ManagePage extends StatefulWidget {
  final bool isResume;

  ManagePage({
    this.isResume = false,
    Key? key,
  }) : super(key: key);

  @override
  _ManagePageState createState() => _ManagePageState();
}

class _ManagePageState extends State<ManagePage> {
  _ManagePageState();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) {
          return PageModel();
        }),
        ChangeNotifierProxyProvider<PageModel, PageStatus>(
          create: (context) {
            var model = Provider.of<PageModel>(context, listen: false);
            return model.status;
          },
          update: (
            BuildContext context,
            PageModel model,
            PageStatus? previous,
          ) {
            return model.status;
          },
        ),
        ChangeNotifierProxyProvider<PageModel, Sidebar>(
          create: (context) {
            var model = Provider.of<PageModel>(context, listen: false);
            return model.sidebar;
          },
          update: (
            BuildContext context,
            PageModel model,
            Sidebar? previous,
          ) {
            return model.sidebar;
          },
        ),
        ChangeNotifierProxyProvider<PageModel, PersonalInfo>(
          create: (context) {
            var model = Provider.of<PageModel>(context, listen: false);
            return model.personalInfo;
          },
          update: (
            BuildContext context,
            PageModel model,
            PersonalInfo? previous,
          ) {
            return model.personalInfo;
          },
        ),
        ChangeNotifierProxyProvider<PageModel, Home>(
          create: (context) {
            var model = Provider.of<PageModel>(context, listen: false);
            return model.home;
          },
          update: (
            BuildContext context,
            PageModel model,
            Home? previous,
          ) {
            return model.home;
          },
        ),
        ChangeNotifierProxyProvider<PageModel, ChangePassword>(
          create: (context) {
            var model = Provider.of<PageModel>(context, listen: false);
            return model.changePassword;
          },
          update: (
            BuildContext context,
            PageModel model,
            ChangePassword? previous,
          ) {
            return model.changePassword;
          },
        ),

                ChangeNotifierProxyProvider<PageModel, BottomNavigationBarPage>(
          create: (context) {
            var model = Provider.of<PageModel>(context, listen: false);
            return model.bottomNavigation;
          },
          update: (
            BuildContext context,
            PageModel model,
            BottomNavigationBarPage? previous,
          ) {
            return model.bottomNavigation;
          },
        ),
      ],
      child: PageScreen(),
    );
  }
}
