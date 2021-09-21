import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/screens/registration/registration_action.dart';
import 'package:egat_flutter/screens/registration/state/location.dart';
import 'package:egat_flutter/screens/registration/widgets/login_text_button.dart';
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

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

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
        appBar: _buildAppbar(context),
        body: SafeArea(
          child: _buildAction(context),
        ),
      ),
    );
  }

  AppBar _buildAppbar(BuildContext context) {
    return AppBar(
      title: Text(
        "Back",
        style: TextStyle(
          color: Theme.of(context).textTheme.bodyText2!.color,
          fontSize: 16,
        ),
        textAlign: TextAlign.left,
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios,
            color: Theme.of(context).textTheme.bodyText2!.color),
        onPressed: () => _onBackPressed(),
      ),
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
                      style: TextStyle(color: Theme.of(context).primaryColor)),
                ],
              ),
            )),
        preferredSize: Size.fromHeight(50),
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
                        actionLabel: const Text("Next"),
                        onAction: _onNextPressed,
                      ),
                      LoginTextButton(),
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
              controller: _locationController,
              decoration: InputDecoration(
                counterText: '',
                labelText: 'Location',
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
    return AspectRatio(
      aspectRatio: 1 / 1,
      child: Placeholder(),
      // child: GoogleMap(
      //   mapType: MapType.hybrid,
      //   initialCameraPosition: _kGooglePlex,
      //   onMapCreated: (GoogleMapController controller) {
      //     // _controller.complete(controller);
      //   },
      // ),
    );
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
                    text: 'if your location does not match in map,' +
                        ' please contact us ',
                  ),
                  TextSpan(
                    text: 'Click',
                    style: TextStyle(color: textButton),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        _onClickPressed();
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

  void _onNextPressed() {
    var model = Provider.of<Location>(context, listen: false);
    model.nextPage();
  }

  void _onBackPressed() {
    var model = Provider.of<Location>(context, listen: false);
    model.backPage();
  }

  void _onClickPressed() {
    logger.i("${DateTime.now()}tap");
  }
}
