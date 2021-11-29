import 'dart:async';

import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/screens/page/state/bilateral/bilateral_sell.dart';
import 'package:egat_flutter/screens/page/trade/bottom_button.dart';
import 'package:egat_flutter/screens/page/widgets/logo_appbar.dart';
import 'package:egat_flutter/screens/page/widgets/page_appbar.dart';
import 'package:egat_flutter/screens/page/widgets/page_bottom_navigation_bar.dart';
import 'package:egat_flutter/screens/page/widgets/side_menu.dart';
import 'package:egat_flutter/screens/page/trade/tabbar.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class BilateralSellScreen extends StatefulWidget {
  const BilateralSellScreen({Key? key}) : super(key: key);

  @override
  _BilateralSellScreenState createState() => _BilateralSellScreenState();
}

class _BilateralSellScreenState extends State<BilateralSellScreen> {
 String _offerinit = "";
  String _date = "";
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
        appBar: PageAppbar(firstTitle: "Bilateral", secondTitle: "Sell"),
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
                          _buildPeriodCard(
                              "A", "Prosumer P02", "14:23, 20 Aug", 8.00, 3.05),
                          _buildPeriodCard(
                              "B", "Prosumer P02", "14:23, 20 Aug", 8.00, 3.05),
                          _buildPeriodCard(
                              "D", "Prosumer P02", "14:23, 20 Aug", 8.00, 3.05),
                          _buildPeriodCard(
                              "D", "Prosumer P02", "14:23, 20 Aug", 8.00, 3.05),
                        ],
                      ),
                    ),
                  ),
                ),
                BottomButton(
                    onAction: _onPlaceOrderPressed, actionLabel: Text("Place Order"))
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

  Widget _buildPeriodCard(
      String position, String title, String date, double kwh, double price) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
      child: Card(
        child: IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: primaryColor,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(position, style: TextStyle(color: blackColor)),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(date)
                    ],
                  ),
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
                padding: EdgeInsets.all(12),
                child: Column(
                  children: [
                    Text(
                      price.toString(),
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      "kWh",
                      style: TextStyle(fontSize: 12),
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
                    EdgeInsets.only(top: 12, bottom: 12, left: 12, right: 24),
                child: Column(
                  children: [
                    Text(
                      price.toString(),
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      "THB",
                      style: TextStyle(fontSize: 12),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
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
                'Offer to sell',
                style: TextStyle(fontSize: 24, color: greenColor),
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
    BilateralSell model = Provider.of<BilateralSell>(context, listen: false);
    model.setPageBack();
    return false;
  }

  void _onPlaceOrderPressed() {
    //Navigate
    BilateralSell model = Provider.of<BilateralSell>(context, listen: false);
    model.setPageBilateralShortTermSell();
  }

  void _onLongTermBilateralPressed() {
    //Navigate
    BilateralSell model = Provider.of<BilateralSell>(context, listen: false);
    model.setPageBilateralLongTermSell();
  }
}
