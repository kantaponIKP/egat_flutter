import 'dart:async';

import 'package:egat_flutter/screens/page/state/bilateral/bilateral_buy.dart';
import 'package:egat_flutter/screens/page/trade/bottom_button.dart';
import 'package:egat_flutter/screens/page/widgets/page_appbar.dart';
import 'package:egat_flutter/screens/page/widgets/page_bottom_navigation_bar.dart';
import 'package:egat_flutter/screens/page/widgets/side_menu.dart';
import 'package:egat_flutter/screens/page/trade/tabbar.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:egat_flutter/constant.dart';

class BilateralBuyScreen extends StatefulWidget {
  const BilateralBuyScreen({Key? key}) : super(key: key);

  @override
  _BilateralBuyScreenState createState() => _BilateralBuyScreenState();
}

class _BilateralBuyScreenState extends State<BilateralBuyScreen> {
  String _offerinit = "";
  String _date = "";
  bool _isChecked = false;
  double _currentSliderValue = 9;
  Completer<GoogleMapController> _controller = Completer();
  var offerItem = [
    "Lowest Price",
    "Highest Price",
    "Lowest Energy",
    "Highest Energy"
  ];

  @override
  void initState() {
    super.initState();
    _offerinit = offerItem.first;
    _date = "14:00-15:00, 21 August 2021";
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: PageAppbar(firstTitle: "Bilateral", secondTitle: "Buy"),
        body: SafeArea(
          child: _buildAction(context),
        ),
      ),
    );
  }

  Padding _buildAction(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 6), 
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildBalanceSection(),
                          _buildDateSection(),
                          SizedBox(height: 12),
                          SizedBox(height: 170, child: _buildMap(context)),
                          SizedBox(height: 12),
                          _buildSelectionSection(),
                          _buildExpansionTile(
                              "A", "Prosumer P02", "14:23, 20 Aug", 18.48, 4.45,4.00,3.15,12.60,1.15,4.60,0.08,1.20,18.48,4.62),
                          _buildExpansionTile(
                              "B", "Prosumer P02", "14:23, 20 Aug", 18.48, 4.45,4.00,3.15,12.60,1.15,4.60,0.08,1.20,18.48,4.62),
                        ],
                      ),
                    ),
                  ),
                ),
                BottomButton(
                    onAction: _onSubmitPressed, actionLabel: Text("Submit"))
              ]);
        },
      ),
    );
  }

  Widget _buildMap(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2 / 1,
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition:
            CameraPosition(target: LatLng(101, 202), zoom: 1),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: Set<Marker>.of(
          <Marker>[
            Marker(
              draggable: true,
              markerId: MarkerId("1"),
              position: LatLng(101, 202),
              icon: BitmapDescriptor.defaultMarker,
              infoWindow: const InfoWindow(
                title: 'Your location',
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _headerTile(String position, String title, String date,
      double estimated, double price) {
    return
        // Container(
        //     padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        //     decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
        //     child:
        ListTile(
      title: CheckboxListTile(
        value: _isChecked,
        onChanged: (bool? value) {
          setState(() {
            _isChecked = value!;
          });
        },
        controlAffinity: ListTileControlAffinity.leading,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        activeColor: primaryColor,
        checkColor: backgroundColor,
        contentPadding: EdgeInsets.all(0),
        title: Container(
          // color: greyColor,
          child: IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 2),
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: primaryColor,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(position,
                            style: TextStyle(color: blackColor, fontSize: 8)),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 12, bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(fontSize: 10),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        date,
                        style: TextStyle(fontSize: 10),
                      )
                    ],
                  ),
                ),
                VerticalDivider(
                  indent: 10,
                  endIndent: 10,
                  width: 12,
                  thickness: 2,
                  color: greyColor,
                ),
                Container(
                  padding:
                      EdgeInsets.only(top: 12, bottom: 12, left: 0, right: 0),
                  child: Column(
                    children: [
                      Text(
                        price.toString(),
                        style: TextStyle(fontSize: 10),
                      ),
                      Text(
                        "kWh",
                        style: TextStyle(fontSize: 8),
                      )
                    ],
                  ),
                ),
                VerticalDivider(
                  indent: 10,
                  endIndent: 10,
                  width: 12,
                  thickness: 2,
                  color: greyColor,
                ),
                Expanded(
                  child: Container(
                    padding:
                        EdgeInsets.only(top: 12, bottom: 12, left: 0, right: 0),
                    child: Column(
                      children: [
                        RichText(
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            style: TextStyle(fontSize: 8),
                            children: <TextSpan>[
                              TextSpan(text: "Estimated buy "),
                              TextSpan(text: estimated.toString()),
                              TextSpan(text: " THB"),
                            ],
                          ),
                        ),
                        RichText(
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            style: TextStyle(fontSize: 8),
                            children: <TextSpan>[
                              TextSpan(text: "NET energy price "),
                              TextSpan(text: price.toString()),
                              TextSpan(text: " THB/kWh"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExpansionTile(
      String position,
      String title,
      String date,
      double estimated,
      double price,
      double energyToBuy,
      double energyTariff,
      double energyPrice,
      double wheelingChargeTariff,
      double wheelingCharge,
      double tradingFee,
      double vat,
      double estimatedBuy,
      double netEstimated) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: ExpansionTile(
            // tilePadding: EdgeInsets.only(left: 0, top: 0, bottom: 0, right: 0),
            // controlAffinity: ListTileControlAffinity.platform,
            // title: _headerTile(position, title, date, estimated, price),
            tilePadding: EdgeInsets.only(left: 0, top: 0, bottom: 0, right: 15),
              controlAffinity: ListTileControlAffinity.platform,
              title: _headerTile(position, title, date, estimated, price),
              collapsedBackgroundColor: surfaceGreyColor,
              backgroundColor: surfaceGreyColor,
              textColor: textColor,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Energy to buy",
                              style: TextStyle(
                                color: textColor,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                energyToBuy.toString(),
                                style: TextStyle(fontSize: 12),
                              ),
                              Text(
                                " kWh",
                                style: TextStyle(fontSize: 12),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Energy to price",
                              style: TextStyle(
                                color: textColor,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                energyTariff.toString(),
                                style: TextStyle(fontSize: 12),
                              ),
                              Text(
                                " THB/kWh",
                                style: TextStyle(fontSize: 10),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              energyTariff.toString(),
                              style: TextStyle(
                                color: textColor,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                energyPrice.toString(),
                                style: TextStyle(fontSize: 12),
                              ),
                              Text(
                                " kWh",
                                style: TextStyle(fontSize: 12),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Wheeling charge Tariff",
                              style: TextStyle(
                                color: textColor,
                                fontSize: 10,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                wheelingChargeTariff.toString(),
                                style: TextStyle(fontSize: 12),
                              ),
                              Text(
                                " THB/kWh",
                                style: TextStyle(fontSize: 10),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Wheeling charge",
                              style: TextStyle(
                                color: textColor,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                wheelingCharge.toString(),
                                style: TextStyle(fontSize: 12),
                              ),
                              Text(
                                " THB/kWh",
                                style: TextStyle(fontSize: 10),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Trading fee",
                              style: TextStyle(
                                color: textColor,
                                fontSize: 10,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                tradingFee.toString(),
                                style: TextStyle(fontSize: 12),
                              ),
                              Text(
                                " THB/kWh",
                                style: TextStyle(fontSize: 10),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Vat (7%)",
                              style: TextStyle(
                                color: textColor,
                                fontSize: 10,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                vat.toString(),
                                style: TextStyle(fontSize: 12),
                              ),
                              Text(
                                " THB/kWh",
                                style: TextStyle(fontSize: 10),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Estimated buy",
                              style: TextStyle(
                                color: textColor,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                estimatedBuy.toString(),
                                style: TextStyle(fontSize: 12),
                              ),
                              Text(
                                " THB/kWh",
                                style: TextStyle(fontSize: 10),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Net estimated energy price",
                              style: TextStyle(
                                color: textColor,
                                fontSize: 10,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                netEstimated.toString(),
                                style: TextStyle(fontSize: 12),
                              ),
                              Text(
                                " THB/kWh",
                                style: TextStyle(fontSize: 10),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ]),
      ),
    );
  }
  Widget _buildDateSection() {
    return Row(children: [
      RichText(
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        text: TextSpan(
          text: _date,
          style: TextStyle(
            color: textColor,
            fontSize: (20),
          ),
        ),
      ),
    ]);
  }

  Widget _buildSelectionSection() {
    return Row(
      // mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceAround,

      children: [
        Container(
          // margin: EdgeInsets.only(top: 10),
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
          height: 35,
          width: 120,
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search",
                    hintStyle: TextStyle(
                      color: blackColor,
                    ),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  ),
                  onChanged: (String keyword) {},
                ),
              ),
              Icon(
                Icons.search,
                color: blackColor,
              )
            ],
          ),
        ),
        Row(
          children: [
            Text("Sort by : "),
            Container(
              height: 35,
              padding: EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(5),
              ),
              child: DropdownButton(
                value: _offerinit,
                icon: Icon(Icons.arrow_drop_down_rounded),
                iconSize: 20,
                iconEnabledColor: backgroundColor,
                dropdownColor: primaryColor,
                style: TextStyle(fontSize: 16, color: backgroundColor),
                alignment: Alignment.center,
                borderRadius: BorderRadius.circular(20),
                onChanged: (String? newValue) {
                  setState(() {
                    _offerinit = newValue!;
                  });
                },
                items: offerItem.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(items),
                  );
                }).toList(),
                underline: DropdownButtonHideUnderline(
                  child: Container(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBalanceSection() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose to buy',
                style: TextStyle(fontSize: 24, color: redColor),
              ),
              Text("Short term Bilateral", style: TextStyle(fontSize: (16))),
            ],
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: _onLongTermBilateralPressed, // null return disabled
              child: Row(children: [
                Icon(Icons.refresh),
                RichText(
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      text: "Long term Bilateral",
                      style: TextStyle(color: blackColor)),
                  // ],
                  // ),
                ),
              ]),
              style: ElevatedButton.styleFrom(
                elevation: 0,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<bool> _onWillPop() async {
    BilateralBuy model = Provider.of<BilateralBuy>(context, listen: false);
    model.setPageBack();
    return false;
  }

  void _onLongTermBilateralPressed() {
    //Navigate
    BilateralBuy model = Provider.of<BilateralBuy>(context, listen: false);
    model.setPageBilateralLongTermBuy();
  }

  void _onSubmitPressed() {
    //Navigate
    BilateralBuy model = Provider.of<BilateralBuy>(context, listen: false);
    model.setPageBilateralTrade();
  }
}
