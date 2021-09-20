import 'package:egat_flutter/i18n/app_language.dart';
import 'package:egat_flutter/i18n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:egat_flutter/constant.dart';
import 'package:provider/provider.dart';

class ForgotScreen extends StatefulWidget {
  const ForgotScreen({Key? key}) : super(key: key);

  @override
  _ForgotScreenState createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController? _emailController;

  // TextEditingController? _passwordController;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            gradient: RadialGradient(colors: [
          Color(0xFF303030),
          Colors.black,
        ])),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          extendBodyBehindAppBar: true,
          appBar: _buildAppBar(context),
          body: SafeArea(
            child: _buildAction(context),
          ),
        ));
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text("Back",
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyText2!.color,
            fontSize: 16,
          ),
          textAlign: TextAlign.left),
      leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: Theme.of(context).textTheme.bodyText2!.color),
          onPressed: () => Navigator.pop(context)),
      centerTitle: false,
      titleSpacing: 0.0,
      leadingWidth: 32,
      elevation: 0,
      backgroundColor: Colors.transparent,
      bottom: PreferredSize(
          child: Container(
              padding: const EdgeInsets.only(left: 32, right: 32, bottom: 16),
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(
                  // style: DefaultTextStyle.of(context).style,
                  style: TextStyle(fontSize: 30),
                  children: <TextSpan>[
                    TextSpan(text: 'Create'),
                    TextSpan(
                        text: ' Account',
                        style:
                            TextStyle(color: Theme.of(context).primaryColor)),
                  ],
                ),
              )),
          preferredSize: Size.fromHeight(50)),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   var appLanguage = Provider.of<AppLanguage>(context);
  //   return Scaffold(
  //     backgroundColor: Theme.of(context).backgroundColor,
  //     appBar: _buildAppBar(context, appLanguage),
  //     resizeToAvoidBottomInset: false,
  //     body: SafeArea(
  //       child: _buildAction(context),
  //     ),
  //   );
  // }

  // AppBar _buildAppBar(BuildContext context, appLanguage) {
  //   var appLanguage = Provider.of<AppLanguage>(context);
  //   return AppBar(
  //     backgroundColor: backgroundColor,
  //     leading: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         IconButton(
  //           icon: Icon(Icons.arrow_back, color: primaryColor),
  //           onPressed: () => Navigator.of(context).pop(),
  //         ),
  //       ],
  //     ),
  //     title: Text(
  //       "Track your Shipment",
  //     ),
  //     actions: [
  //       Row(
  //         children: [
  //           IconButton(
  //             icon: Icon(Icons.access_alarm, color: primaryColor),
  //             onPressed: () {
  //               appLanguage.changeLanguage(Locale("en"));
  //             },
  //           ),
  //           IconButton(
  //             icon: Icon(Icons.all_inbox, color: primaryColor),
  //             onPressed: () {
  //               appLanguage.changeLanguage(Locale("th"));
  //             },
  //           ),
  //         ],
  //       ),
  //     ],
  //   );
  // }

  Padding _buildAction(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 32, right: 32, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // _buildTitle(context),
          _buildContent(context),
          _buildForm(context),
          _buildResetButton(context),
        ],
      ),
    );
  }

  // Widget _buildTitle(BuildContext context) {
  //   return RichText(
  //       text: TextSpan(
  //           style: DefaultTextStyle.of(context).style,
  //           children: <TextSpan>[
  //         TextSpan(
  //             text: AppLocalizations.of(context).translate("forget"),
  //             // text: "Forget",
  //             style: TextStyle(fontSize: 30)),
  //         TextSpan(
  //             text: 'Password',
  //             style: TextStyle(fontSize: 30, color: primaryColor)),
  //       ]));
  // }

  Widget _buildContent(BuildContext context) {
    return Container(
      child: Text(
          'Enter the email associated with your account and we’ll send an email with structions to reset your password. ',
          style: TextStyle(fontSize: 16)),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 50),
            child: TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                counterText: '',
                labelText: 'Email',
              ),
              validator: (value) {
                if (value == null || value.trim().length == 0) {
                  return "Require email";
                }
                return null;
              },
              keyboardType: TextInputType.emailAddress,
              maxLength: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResetButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          // _onLogin(context);
        },
        child: const Text("Reset Password"),
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: EdgeInsets.all(12),
          // primary: primaryColor,
          // color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
