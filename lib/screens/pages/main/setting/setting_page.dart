import 'package:egat_flutter/screens/pages/main/main_screen.dart';
import 'package:egat_flutter/screens/pages/main/setting/addPayment_status.dart';
import 'package:egat_flutter/screens/pages/main/setting/setting_screen.dart';
import 'package:egat_flutter/screens/pages/main/setting/state/setting_screen_navigation_state.dart';
import 'package:egat_flutter/screens/pages/main/states/main_screen_title_state.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SettingScreenNavigationState>(
          create: (_) => SettingScreenNavigationState(),
        ),
        ChangeNotifierProvider<AddPaymentStatus>(
           create: (_) => AddPaymentStatus(),
          // create: (context) {
          //   var model = Provider.of<PageModel>(context, listen: false);
          //   return model.status;
          // },
          // update: (
          //   BuildContext context,
          //   PageModel model,
          //   RegistrationStatus? previous,
          // ) {
          //   return model.status;
          // },
        ),
      ],
      child: SettingScreen(),
    );
  }
}
