import 'package:egat_flutter/screens/registration/registration_action.dart';
import 'package:egat_flutter/screens/registration/registration_model.dart';
import 'package:egat_flutter/screens/registration/registration_screen.dart';
import 'package:egat_flutter/screens/registration/registration_step_indicator.dart';
import 'package:egat_flutter/screens/registration/state/otp.dart';
import 'package:egat_flutter/screens/registration/state/registration_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class OtpPinScreen extends StatefulWidget {
  OtpPinScreen({Key? key}) : super(key: key);

  @override
  _OtpPinScreenState createState() => _OtpPinScreenState();
}

class PinTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length < oldValue.text.length) {
      return newValue;
    }

    if (!_isNumeric(newValue.text)) {
      return oldValue;
    }

    return newValue;
  }

  bool _isNumeric(String string) {
    final numericRegex = RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$');

    return numericRegex.hasMatch(string);
  }
}

class _OtpPinScreenState extends State<OtpPinScreen> {
  TextEditingController? _pinController;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _pinController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          _onCancel();

          return true;
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Expanded(
                  flex: 10,
                  child: ListView(
                    children: [
                      SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          "ยืนยัน OTP",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      RegistrationStepIndicator(),
                      SizedBox(height: 32),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 32),
                        child: Opacity(
                          opacity: 0.70,
                          child: AspectRatio(
                            aspectRatio: 3,
                            child: _buildLogo(),
                          ),
                        ),
                      ),
                      SizedBox(height: 48),
                      _buildForm(),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                RegistrationAction(
                  actionLabel: const Text("ยืนยัน"),
                  onAction: _onSubmit,
                ),
                SizedBox(
                  height: 16,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();

    _pinController!.dispose();
  }
  
  Widget _buildForm() {
    var otp = Provider.of<Otp>(context, listen: false);
    var session = Provider.of<RegistrationSession>(context, listen: false);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 48),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                "กรุณาใส่ OTP ที่ได้รับ",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Align(
                alignment: Alignment.center,
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: "รหัสได้ถูกส่งไปที่เบอร์โทรศัพท์ ",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      TextSpan(
                        // text: "${session.info!.mobileNumber}",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: PinCodeTextField(
                inputFormatters: [],
                keyboardType: TextInputType.numberWithOptions(
                  signed: false,
                  decimal: false,
                ),
                length: 6,
                validator: (value) {
                  if (value == null) {
                    return "ต้องเป็นตัวเลข 6 หลัก";
                  }

                  if (value.trim().length != 6) {
                    return "ต้องเป็นตัวเลข 6 หลัก";
                  }

                  if (!_isNumeric(value)) {
                    return "ต้องเป็นตัวเลข 6 หลัก";
                  }

                  return null;
                },
                controller: _pinController,
                onChanged: (String value) {},
                appContext: context,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "Ref: ${otp.reference ?? "ERROR: NO OTP Reference detected"}",
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return FittedBox(child: Icon(Icons.sms, color: Colors.green.shade700));
  }

  bool _isNumeric(String string) {
    final numericRegex = RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$');

    return numericRegex.hasMatch(string);
  }

  void _onCancel() {
    FocusScope.of(context).unfocus();
    askForRegistrationCancelConfirmation(context);
  }

  void _onSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    FocusScope.of(context).unfocus();

    await showLoading();

    try {
      var otp = Provider.of<Otp>(context, listen: false);

      if (!await otp.submitOtp(_pinController!.text)) {
        _showOtpIsNotValidError();
      }
    } catch (e) {
      showException(context, e.toString());
    } finally {
      await hideLoading();
    }
  }

  void _showOtpIsNotValidError() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("ผิดพลาด"),
        content: const Text("OTP ไม่ถูกต้อง"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              "ปิดหน้าต่าง",
              style: TextStyle(
                // color: neutralColor,
              ),
            ),
          )
        ],
      ),
    );
  }
}
