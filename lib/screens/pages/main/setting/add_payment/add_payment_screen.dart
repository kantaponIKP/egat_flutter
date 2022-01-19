import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/i18n/app_localizations.dart';
import 'package:egat_flutter/screens/page/widgets/page_appbar.dart';
import 'package:egat_flutter/screens/pages/main/setting/addPayment_step_indicator.dart';
import 'package:egat_flutter/screens/pages/main/setting/add_payment/states/add_payment_state.dart';
import 'package:egat_flutter/screens/pages/main/setting/card_payment/card_payment_page.dart';
import 'package:egat_flutter/screens/pages/main/setting/state/setting_screen_navigation_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class AddPaymentScreen extends StatefulWidget {
  const AddPaymentScreen({Key? key}) : super(key: key);

  @override
  _AddPaymentScreenState createState() => _AddPaymentScreenState();
}

class _AddPaymentScreenState extends State<AddPaymentScreen> {
  final _formKey = GlobalKey<FormState>();

  List<bool> _isChecked = [false, false];

  // @override
  // void initState() {
  //   super.initState();

  //   final titleState =
  //       Provider.of<MainScreenTitleState>(context, listen: false);

  //   titleState.setTitleOneTitle(title: 'Add Payment');
  // }

    @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
     SettingScreenNavigationState settingScreenNavigationState =
        Provider.of<SettingScreenNavigationState>(context, listen: false);
    settingScreenNavigationState.setPageToAddPayment();
    return Scaffold(
      appBar: PageAppbar(
          firstTitle: "",
          secondTitle:
              AppLocalizations.of(context).translate('title-addPayment')),
      // drawer: NavigationMenuWidget(),
      body: SafeArea(
        child: _buildAction(context),
      ),
    );
  }

  Padding _buildAction(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 48, right: 48, top: 12, bottom: 6),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // SizedBox(height: 24),
                  _buildSelectionSection(),
                  SizedBox(height: 24),
                  _buildPaymentMethodsSection(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSelectionSection() {
    return Column(
      children: [
        _buildPayment(
            Container(
                height: 40,
                width: 80,
                child: SvgPicture.asset(
                    'assets/images/icons/payment/cardPayment.svg')),
            AppLocalizations.of(context).translate('payment-cardPayment'),
            0),
        SizedBox(height: 24),
        _buildPayment(
            Container(
                height: 40,
                width: 80,
                color: whiteColor,
                child: Image(
                    // width: 24,
                    image: AssetImage(
                        'assets/images/icons/payment/promptPay.png'))),
            AppLocalizations.of(context).translate('payment-promptPay'),
            1)
      ],
    );
  }

  Widget _buildPayment(icon, title, index) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 8),
        color: surfaceGreyColor,
        child: // ListTile(
            CheckboxListTile(
          value: _isChecked[index],
          onChanged: (bool? value) {
            setState(() {
              if(index == 0){
                _isChecked[0] = true;
                _isChecked[1] = false;
              }else if(index == 1){
                _isChecked[0] = false;
                _isChecked[1] = true;
              }
            });
          },
          // controlAffinity: ListTileControlAffinity.leading,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
          secondary: icon,
          activeColor: primaryColor,
          checkColor: backgroundColor,
          contentPadding: EdgeInsets.all(0),
          title: Text(title),
        ));
  }

  Widget _buildPaymentMethodsSection() {
    return Column(
      children: [
        SizedBox(
          child: ElevatedButton(
            onPressed:
                (_isChecked[0]) ? onNextPressed : null, // null return disabled
            child: Row(
              children: [
                Spacer(),
                Text(AppLocalizations.of(context).translate('next')),
                Spacer(),
              ],
            ),
            style: ElevatedButton.styleFrom(
              elevation: 0,
            ),
          ),
        ),
        SizedBox(
          height: 30.0,
          child: AddPaymentStepIndicator(),
        ),
      ],
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const CardPaymentPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // const begin = Offset(1.0, 0.0);
        // const end = Offset.zero;
        // const curve = Curves.ease;
        // var tween =
        //     Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return child;
      },
    );
  }

  Future<void> onNextPressed() async {

    final result = await Navigator.of(context).push(_createRoute());

    if (result != null && result) {
      Navigator.pop(context, true);
    }

    // AddPaymentState addPayment = Provider.of<AddPaymentState>(context, listen: false);
    // addPayment.nextPage();

    // SettingScreenNavigationState addPayment =
    //     Provider.of<SettingScreenNavigationState>(context, listen: false);
    // addPayment.setPageToCardPayment();
    //  MainScreenTitleState mainScreenTitle =
    //     Provider.of<MainScreenTitleState>(context, listen: false);
    // mainScreenTitle.setTitleOneTitle(
    //     title: AppLocalizations.of(context).translate('title-cardPayment'));
  }
}
