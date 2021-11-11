import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/i18n/app_localizations.dart';
import 'package:egat_flutter/screens/page/state/personal_info.dart';
import 'package:egat_flutter/screens/page/widgets/logo_appbar.dart';
import 'package:egat_flutter/screens/page/widgets/page_appbar.dart';
import 'package:egat_flutter/screens/page/widgets/page_bottom_navigation_bar.dart';
import 'package:egat_flutter/screens/page/widgets/side_menu.dart';
import 'package:egat_flutter/screens/page/trade/tabbar.dart';
import 'package:egat_flutter/screens/widgets/loading_dialog.dart';
import 'package:egat_flutter/screens/widgets/show_exception.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io' as Io;

class ForecastScreen extends StatefulWidget {
  const ForecastScreen({Key? key}) : super(key: key);

  @override
  _ForecastScreenState createState() => _ForecastScreenState();
}

class _ForecastScreenState extends State<ForecastScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  TextEditingController? _fullNameController;
  TextEditingController? _phoneNumberController;
  TextEditingController? _emailController;
  String? _fullName;
  String? _phoneNumber;
  String? _email;
  bool _isValidated = false;
  bool _isFormChanged = false;
  String? _imageBase64;

  @override
  void initState() {
    super.initState();

    _fullNameController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _emailController = TextEditingController();

    _getPersonalInformation();
  }

  void _getPersonalInformation() async {
    var model = Provider.of<PersonalInfo>(context, listen: false);
    await showLoading();
    try {
      await model.getPersonalInformation();
    } catch (e) {
      showException(context, e.toString());
    } finally {
      if (model.info.fullName != null) {
        _fullNameController!.text = model.info.fullName!;
        _fullName = model.info.fullName!;
      }
      if (model.info.phoneNumber != null) {
        _phoneNumberController!.text = model.info.phoneNumber!;
        _phoneNumber = model.info.phoneNumber!;
      }
      if (model.info.email != null) {
        _emailController!.text = model.info.email!;
        _email = model.info.email!;
      }
      if (model.info.photo != null) {
        setState(() {
          _imageBase64 = model.info.photo!;
        });
      }
      await hideLoading();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LogoAppbar(),
      drawer: NavigationMenuWidget(),
      body: SafeArea(
        child: _buildAction(context),
      ),
      bottomNavigationBar: PageBottomNavigationBar(),
    );
  }

  Padding _buildAction(BuildContext context) {
    return Padding(
      // padding: const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 6),
      padding: const EdgeInsets.only(top: 12, bottom: 6),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return
              // _buildTapbar();

              SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Tabbar(),
                  _buildEnergyBalance(),
                  _buildEnergyWidgetList(),
                  // _buildEnergyWidget(),
                  Container(height: 300, child: Placeholder()),
                  _buildHeaderWidget(),
                  _buildListTile(),
                  // _buildAvatarSection(),
                  // _buildNameSection(),
                  // SizedBox(height: 12),
                  // _buildInformationSection(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Container(
              // decoration: BoxDecoration(borderRadius: ),
              height: 50,
              child: Row(
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 2,
                    child: Row(children: [
                      Checkbox(
                        value: false,
                        onChanged: (null),
                      ),
                      Text("All"),
                    ]),
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 2,
                    child: RichText(
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(text: "Period"),
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 2,
                    child: Container(
                      child: Row(
                        children: [
                          Container(width: 12, height: 12, color: primaryColor),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: RichText(
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(text: "Can Sell"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 2,
                    child: //
                        Row(
                      children: [
                        Container(width: 12, height: 12, color: orangeColor),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: RichText(
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(text: "Must buy"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
    // return Padding(
    //   padding:
    //       const EdgeInsets.only(left: 16.0, right: 16.0, top: 8, bottom: 8),
    //   child: Row(
    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //     children: [
    //       Row(
    //         children: [
    //           SizedBox(
    //             height: 24.0,
    //             width: 24.0,
    //             child: Checkbox(value: false, onChanged: (null)),
    //           ),
    //           Padding(
    //             padding: const EdgeInsets.only(left: 2.0),
    //             child: RichText(
    //               overflow: TextOverflow.ellipsis,
    //               text: TextSpan(text: "All"),
    //             ),
    //           ),
    //         ],
    //       ),
    //       RichText(
    //         overflow: TextOverflow.ellipsis,
    //         text: TextSpan(text: "Period"),
    //       ),
    //       Row(
    //         children: [
    //           Container(width: 12, height: 12, color: primaryColor),
    //           Padding(
    //             padding: const EdgeInsets.only(left: 8.0),
    //             child: RichText(
    //               overflow: TextOverflow.ellipsis,
    //               text: TextSpan(text: "Can Sell"),
    //             ),
    //           ),
    //         ],
    //       ),
    //       Row(
    //         children: [
    //           Container(width: 12, height: 12, color: orangeColor),
    //           Padding(
    //             padding: const EdgeInsets.only(left: 8.0),
    //             child: RichText(
    //               overflow: TextOverflow.ellipsis,
    //               text: TextSpan(text: "Must buy"),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ],
    //   ),
    // );
  }

  Widget _buildEnergyWidgetList() {
    return
        // ListView(
        //   shrinkWrap: true,
        //   children: <Widget>[
        // _buildEnergyWidget(),
        // _buildEnergyWidget(),
        // _buildEnergyWidget(),
        // _buildEnergyWidget(),
        new Container(
      height: 84,
      child: new ListView(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          children: [
            _buildEnergyWidget("Today", "33.7", 1),
            _buildEnergyWidget("20 August 2021", "12.5", 0.3),
            _buildEnergyWidget("19 August 2021", "7.43", 0.3),
            _buildEnergyWidget("18 August 2021", "6.1", 0.3),
          ]
          // new List.generate(10, (int index) {
          //   return new Card(
          //     color: Colors.blue[index * 100],
          //     child: new Container(
          //       width: 50.0,
          //       height: 50.0,
          //       child: new Text("$index"),
          //     ),
          //   );
          // }
          ),
    );
    // ),
    // ],
  }

  Widget _buildListTile() {
    return Container(
      // height: MediaQuery.of(context).size.height,
      child: ListView(
        shrinkWrap: true,
        // scrollDirection: Axis.horizontal,
        children: <Widget>[
          //       Expanded(
          //   child: ListTile(
          //     leading: FlutterLogo(),
          //     title: Text('These ListTiles are expanded '),
          //     trailing: Container(child: Row())
          //   ),
          // ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(5),),
                    height: 50,
                    // color: Colors.grey[800],
                    child: Row(
                      children: [
                        Flexible(
                          fit: FlexFit.tight,
                          flex: 2,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Checkbox(
                              value: false,
                              onChanged: (null),
                            ),
                          ),
                        ),
                        Flexible(
                          fit: FlexFit.tight,
                          flex: 2,
                          child: Text("14:00-15:00"),
                        ),
                        Flexible(
                          fit: FlexFit.tight,
                          flex: 2,
                          child: Center(
                            child: Text(
                              "4.3 kWh",
                              style: TextStyle(color: primaryColor),
                            ),
                          ),
                        ),
                        Flexible(
                          fit: FlexFit.tight,
                          flex: 2,
                          child: Center(child: Text("0")),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(5),),
                    height: 50,
                    // color: Colors.grey[800],
                    child: Row(
                      children: [
                        Flexible(
                          fit: FlexFit.tight,
                          flex: 2,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Checkbox(
                              value: false,
                              onChanged: (null),
                            ),
                          ),
                        ),
                        Flexible(
                          fit: FlexFit.tight,
                          flex: 2,
                          child: Text("15:00-16:00"),
                        ),
                        Flexible(
                          fit: FlexFit.tight,
                          flex: 2,
                          child: Center(
                            child: Text(
                              "6.1 kWh",
                              style: TextStyle(color: primaryColor),
                            ),
                          ),
                        ),
                        Flexible(
                          fit: FlexFit.tight,
                          flex: 2,
                          child: Center(child: Text("0")),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
          // CheckboxListTile(
          //   // tristate: true,
          //   title: Text('14:00-15:00'),
          //   secondary: Table(
          //     children: [
          //       TableRow(
          //         children: <Widget>[
          //           Container(
          //             height: 32,
          //             color: Colors.green,
          //           ),
          //           TableCell(
          //             verticalAlignment: TableCellVerticalAlignment.top,
          //             child: Container(
          //               height: 32,
          //               width: 32,
          //               color: Colors.red,
          //             ),
          //           ),
          //           Container(
          //             height: 64,
          //             color: Colors.blue,
          //           ),
          //         ],
          //       ),
          //     ],
          //   ),
          //   controlAffinity: ListTileControlAffinity.leading,
          //   value: false,
          //   onChanged: null,
          // ),
          // Card(
          //   child: CheckboxListTile(
          //     // tristate: true,
          //     title: Text('14:00-15:00'),
          //     secondary: Container(
          //       child: Expanded(
          //         child: Row(
          //           children: [
          //             // RichText(
          //             // overflow: TextOverflow.ellipsis,
          //             // text: TextSpan(
          //             //   style: TextStyle(fontSize: 16),
          //             //   children: <TextSpan>[
          //             //     TextSpan(text: "4.3 kWh"),
          //             //     // TextSpan(text: "0"),
          //             //   ],
          //             // ),
          //             // ),
          //           ],
          //         ),
          //       ),
          //     ),
          //     controlAffinity: ListTileControlAffinity.leading,
          //     value: false,
          //     onChanged: null,
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildEnergyWidget(String date, String amount, double opacity) {
    return Opacity(
      opacity: opacity,
      child: Card(
          // color: onBgColor,
          child: Container(
        constraints: BoxConstraints(minHeight: 72),
        width: 132,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                  style: TextStyle(fontSize: 16),
                  children: <TextSpan>[
                    TextSpan(text: date),
                  ],
                ),
              ),
              SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                decoration: BoxDecoration(
                  color: onPrimaryBgColor.withAlpha(60),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      //important for overflow text
                      child: new RichText(
                        text: new TextSpan(
                          children: <TextSpan>[
                            new TextSpan(
                                text: amount,
                                style: TextStyle(
                                  fontSize: 24,
                                  color: primaryColor,
                                )),
                            new TextSpan(text: ' kWh'),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      )),
    );
  }

  Widget _buildEnergyBalance() {
    return Container(
      child: Column(children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Saleable Energy (24 hr. Ahead)'),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Flexible(
                    //important for overflow text
                    child: new RichText(
                      text: new TextSpan(
                        children: <TextSpan>[
                          new TextSpan(
                              text: "33.7",
                              style:
                                  TextStyle(fontSize: 24, color: primaryColor)),
                          new TextSpan(text: 'kWh'),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            new RichText(
              text: new TextSpan(
                children: <TextSpan>[
                  new TextSpan(text: "Past 7-day Forecast"),
                ],
              ),
            )
          ],
        ),
      ]),
    );
  }
}
