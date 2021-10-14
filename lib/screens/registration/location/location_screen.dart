import 'dart:async';
import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/i18n/app_localizations.dart';
import 'package:egat_flutter/screens/registration/location/contact_us_screen.dart';
import 'package:egat_flutter/screens/registration/widgets/registration_action.dart';
import 'package:egat_flutter/screens/registration/registration_step_indicator.dart';
import 'package:egat_flutter/screens/registration/state/location.dart';
import 'package:egat_flutter/screens/registration/state/meter.dart';
import 'package:egat_flutter/screens/registration/widgets/login_text_button.dart';
import 'package:egat_flutter/screens/registration/widgets/signup_appbar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({Key? key}) : super(key: key);

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController? _locationController;
  bool privacyPolicy = false;

  // Completer<GoogleMapController> _controller = Completer();
  Completer<GoogleMapController> _controller = Completer();

  // CameraPosition? _kGooglePlex;
  //  = CameraPosition(target: LatLng(13.736717, 100.523186), zoom: 14.4746);
  // static final CameraPosition _kGooglePlex =
  //     CameraPosition(target: LatLng(13.736717, 100.523186), zoom: 14.4746);

  void initState() {
    super.initState();
    _locationController = TextEditingController();
    getInfo();
  }

  void getInfo() {
    var meter = Provider.of<Meter>(context, listen: false);
    _locationController!.text = meter.info.location!;
    // if(meter.info.latitude != null && meter.info.longtitude != null){
    //    _kGooglePlex = CameraPosition(
    //   // target: LatLng(meter.info.latitude!, meter.info.longtitude!),
    //   target: LatLng(meter.info.latitude!, meter.info.longtitude!),
    //   zoom: 14.4746,
    // );
    // }
   
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [
            Color(0xFF303030),
            Colors.black,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        // appBar: _buildAppbar(context),
        appBar: SignupAppbar(
            firstTitle: '${AppLocalizations.of(context).translate('create')}',
            secondTitle: '${AppLocalizations.of(context).translate('account')}',
            onAction: _onBackPressed),
        body: SafeArea(
          child: _buildAction(context),
        ),
      ),
    );
  }

  Padding _buildAction(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 32, right: 32, bottom: 16),
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
                  Column(
                    children: [
                      _buildForm(context),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: _buildMap(context),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildContactUsText(context),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      RegistrationAction(
                        actionLabel: Text(
                            '${AppLocalizations.of(context).translate('next')}'),
                        onAction: _onNextPressed,
                      ),
                      SizedBox(
                        height: 30.0,
                        child: RegistrationStepIndicator(),
                      ),
                      SizedBox(
                        height: 20.0,
                        child: LoginTextButton(),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: TextFormField(
              maxLines: null,
              enabled: false,
              controller: _locationController,
              decoration: InputDecoration(
                counterText: '',
                labelText:
                    '${AppLocalizations.of(context).translate('location')}',
                disabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).textTheme.bodyText2!.color!,
                  ),
                ),
              ),
              keyboardType: TextInputType.text,
              maxLength: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMap(BuildContext context) {
    var meter = Provider.of<Meter>(context, listen: false);
    logger.d(meter.info.zoomLevel);
    if(meter.info.latitude != null || meter.info.longtitude != null || meter.info.zoomLevel != null){
       return AspectRatio(
      aspectRatio: 1 / 1,
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(target: LatLng(meter.info.latitude!, meter.info.longtitude!), zoom: meter.info.zoomLevel!),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: Set<Marker>.of(
          <Marker>[
            Marker(
              draggable: true,
              markerId: MarkerId("1"),
              position: LatLng(meter.info.latitude!, meter.info.longtitude!),
              icon: BitmapDescriptor.defaultMarker,
              infoWindow: const InfoWindow(
                title: 'Your location',
              ),
            )
          ],
        ),
      ),
    );
    }else{
      return Placeholder();
    }
   
  }

  Widget _buildContactUsText(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                      text:
                          '${AppLocalizations.of(context).translate('map-contacted')} '),
                  TextSpan(
                    text: '${AppLocalizations.of(context).translate('click')} ',
                    style: TextStyle(color: textButton),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        _onClickPressed(context);
                      },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
    // ),
  }

  void _onClickPressed(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return ContactUs();
        });
  }

  void _onNextPressed() {
    var model = Provider.of<Location>(context, listen: false);
    model.nextPage();
  }

  void _onBackPressed() {
    var model = Provider.of<Location>(context, listen: false);
    model.backPage();
  }
}
