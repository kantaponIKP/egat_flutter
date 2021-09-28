import 'package:egat_flutter/screens/registration/state/registration_status.dart';
import 'package:egat_flutter/screens/widgets/horizontal_step_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class RegistrationStepIndicator extends StatelessWidget {
  const RegistrationStepIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var status = Provider.of<RegistrationStatus>(context);
    var stepIndex = 0;
    var theme = HorizontalStepIndicatorTheme.White;
    var isHighlightedDone = false;

    switch (status.state) {
      case RegistrationState.UserInfo:
      case RegistrationState.Password:
      case RegistrationState.Dismiss:
      case RegistrationState.Consent:
        stepIndex = 0;
        break;
      case RegistrationState.Meter:
        stepIndex = 1;
        break;
      case RegistrationState.Location:
        stepIndex = 2;
        break;
      case RegistrationState.Otp:
      case RegistrationState.OtpPin:
        stepIndex = 3;
        break;
      case RegistrationState.Success:
        stepIndex = 5;
        isHighlightedDone = true;
        break;
    }

    // switch (status.state) {
    //   case RegistrationState.IdCardOcr:
    //   case RegistrationState.FaceVerifyCamera:
    //   case RegistrationState.Resume:
    //     theme = HorizontalStepIndicatorTheme.Dark;
    //     break;
    //   default:
    //     break;
    // }

    return HorizontalStepIndicator(
      steps: [
        HorizontalStepItem(title: 'ระบุ\nตัวตน'),
        HorizontalStepItem(title: 'ตรวจสอบ\nบุคคล'),
        HorizontalStepItem(title: 'รหัสผ่าน'),
        HorizontalStepItem(title: 'OTP')
      ],
      theme: theme,
      index: stepIndex,
      highlightDoneStep: isHighlightedDone,
    );
  }
}
