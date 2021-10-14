import 'package:egat_flutter/screens/forgot_password/state/forgot_password_status.dart';
import 'package:egat_flutter/screens/widgets/horizontal_step_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class ForgotPasswordStepIndicator extends StatelessWidget {
  const ForgotPasswordStepIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var status = Provider.of<ForgotPasswordStatus>(context);
    var stepIndex = 0;
    var theme = HorizontalStepIndicatorTheme.White;
    var isHighlightedDone = false;

    switch (status.state) {
      case ForgotPasswordState.Email:
      case ForgotPasswordState.Dismiss:
        stepIndex = 0;
        break;
      case ForgotPasswordState.Otp:
        stepIndex = 1;
        break;
      case ForgotPasswordState.Password:
        stepIndex = 2;
        break;
      case ForgotPasswordState.Success:
        stepIndex = 3;
        isHighlightedDone = true;
        break;
    }

    return HorizontalStepIndicator(
      steps: [
        HorizontalStepItem(title: 'Email'),
        HorizontalStepItem(title: 'Otp'),
        HorizontalStepItem(title: 'Password'),
      ],
      theme: theme,
      index: stepIndex,
      highlightDoneStep: isHighlightedDone,
    );
  }
}
