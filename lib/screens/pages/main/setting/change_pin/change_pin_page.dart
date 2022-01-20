import 'package:egat_flutter/screens/pages/main/setting/change_pin/change_pin_screen.dart';
import 'package:egat_flutter/screens/pages/main/setting/change_pin/states/change_pin_state.dart';
import 'package:egat_flutter/screens/pages/main/setting/change_pin/states/pin_state.dart';
import 'package:egat_flutter/screens/session.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class ChangePinPage extends StatelessWidget {
  const ChangePinPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProxyProvider<PinState, ChangePinState>(
        create: (_) => ChangePinState(),
        update: (_, pin, changePinState) {
          if (changePinState == null) {
            changePinState = ChangePinState();
          }

          return changePinState..setPin(pin);
        },
      ),
    ], child: ChangePinScreen());
  }
}
