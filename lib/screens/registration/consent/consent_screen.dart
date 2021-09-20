import 'package:egat_flutter/screens/registration/registration_screen.dart';
import 'package:egat_flutter/screens/registration/registration_step_indicator.dart';
import 'package:egat_flutter/screens/registration/state/consent.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'consent_text.dart';

class ConsentScreen extends StatefulWidget {
  ConsentScreen({Key? key}) : super(key: key);

  @override
  _ConsentScreenState createState() => _ConsentScreenState();
}

class _ConsentScreenState extends State<ConsentScreen> {
  bool isScrollbarAlwaysShown = true;
  bool isDisposed = false;

  ScrollController? _scrollController;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    isScrollbarAlwaysShown = true;
    isDisposed = false;

    countDownScrollbarShown();
  }

  @override
  void dispose() {
    super.dispose();

    isDisposed = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Column(
            children: [
              Center(
                child: const Text(
                  'หนังสือให้ความยินยอมในการเก็บข้อมูล\nใช้เปิดเผยข้อมูลส่วนบุคคล',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 8,
                  left: 32,
                  right: 32,
                ),
                child: RegistrationStepIndicator(),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(
                    top: 16,
                    bottom: 16,
                    left: 32,
                    right: 24,
                  ),
                  child: Scrollbar(
                    controller: _scrollController,
                    isAlwaysShown: isScrollbarAlwaysShown,
                    child: ListView(
                      controller: _scrollController,
                      children: [
                        Text(consentText),
                      ],
                    ),
                  ),
                ),
              ),
              buildActions(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () => onRejectConsent(context),
            child: Text(
              'ไม่ยอมรับ',
              style: TextStyle(
                // color: neutralColor,
              ),
            ),
          ),
          TextButton(
            child: const Text("ยอมรับ"),
            onPressed: () => onAcceptConsent(context),
          ),
        ],
      ),
    );
  }

  void onRejectConsent(BuildContext context) async {
    var consent = Provider.of<Consent>(context, listen: false);

    await showLoading();

    try {
      await consent.rejectConsent();
    } catch (e) {
      showException(context, e.toString());
    } finally {
      await hideLoading();
    }
  }

  void onAcceptConsent(BuildContext context) async {
    var consent = Provider.of<Consent>(context, listen: false);

    await showLoading();

    try {
      await consent.acceptConsent();
    } catch (e) {
      showException(context, e.toString());
    } finally {
      await hideLoading();
    }
  }

  void countDownScrollbarShown() async {
    await Future.delayed(Duration(seconds: 3));

    if (!isDisposed) {
      setState(() {
        isScrollbarAlwaysShown = false;
      });
    }
  }
}
