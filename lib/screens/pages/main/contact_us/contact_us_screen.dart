import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/i18n/app_localizations.dart';
import 'package:egat_flutter/screens/page/state/personal_info.dart';
import 'package:egat_flutter/screens/page/widgets/logo_appbar.dart';
import 'package:egat_flutter/screens/page/widgets/page_appbar.dart';
import 'package:egat_flutter/screens/page/widgets/page_bottom_navigation_bar.dart';
import 'package:egat_flutter/screens/page/widgets/side_menu.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({Key? key}) : super(key: key);

  @override
  _ContactUsScreenState createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageAppbar(firstTitle: "Contact", secondTitle: "Us"),
      drawer: NavigationMenuWidget(),
      body: SafeArea(
        child: _buildAction(context),
      ),
    );
  }

  Padding _buildAction(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 6),
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
                  _buildInformationSection(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInformationSection() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: InkWell(
        onTap: () {
          print('Card tapped.');
        },
        child: SizedBox(
          child: Center(
              child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(children: [
              _buildContent(),
            ]),
          )),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        Icon(Icons.phone, color: primaryColor, size: 40),
        SizedBox(height: 8),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Tel.',
                style: TextStyle(fontSize: 16)
              ),
              TextSpan(
                text: '089-xxx-xxxx',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: textButton,
                  fontSize: 16,
                ),
                recognizer: TapGestureRecognizer()..onTap = () {},
              ),
            ],
          ),
        ),
        SizedBox(height: 32),
        Icon(Icons.mail, color: primaryColor, size: 40),
        SizedBox(height: 8),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'egat.p2p@gmail.com',
                style: TextStyle(fontSize: 16)
              ),
            ],
          ),
        ),
        SizedBox(height: 32),
        Icon(Icons.location_on, color: primaryColor, size: 40),
        SizedBox(height: 8),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '123 Street 123 Road',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: textButton,
                  fontSize: 16,
                ),
                recognizer: TapGestureRecognizer()..onTap = () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}
