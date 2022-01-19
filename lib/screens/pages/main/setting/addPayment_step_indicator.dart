import 'package:egat_flutter/screens/pages/main/setting/addPayment_status.dart';
import 'package:egat_flutter/screens/pages/main/setting/state/setting_screen_navigation_state.dart';
import 'package:egat_flutter/screens/widgets/horizontal_step_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class AddPaymentStepIndicator extends StatelessWidget {
  const AddPaymentStepIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var status = Provider.of<SettingScreenNavigationState>(context);
    print("current page: ");
    print(status.currentPage);
    var stepIndex = 0;
    var theme = HorizontalStepIndicatorTheme.White;
    var isHighlightedDone = false;

    switch (status.currentPage) {
      case SettingScreenNavigationPage.ADD_PAYMENT:
        stepIndex = 0;
        break;
      case SettingScreenNavigationPage.CARD_PAYMENT:
        stepIndex = 1;
        break;
      case SettingScreenNavigationPage.CHANGE_PIN:
        break;
      case SettingScreenNavigationPage.MAIN:
        break;
    }

    return HorizontalStepIndicator(
      steps: [
        HorizontalStepItem(title: 'AddPayment'),
        HorizontalStepItem(title: 'CardPayment'),
      ],
      theme: theme,
      index: stepIndex,
      highlightDoneStep: isHighlightedDone,
    );
  }
}
