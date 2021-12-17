import 'dart:async';

import 'package:egat_flutter/screens/page/state/bilateral/bilateral_buy.dart';
import 'package:egat_flutter/screens/page/state/bilateral/bilateral_long_term_buy.dart';
import 'package:egat_flutter/screens/page/trade/bottom_button.dart';
import 'package:egat_flutter/screens/page/widgets/page_appbar.dart';
import 'package:egat_flutter/screens/page/widgets/page_bottom_navigation_bar.dart';
import 'package:egat_flutter/screens/page/widgets/side_menu.dart';
import 'package:egat_flutter/screens/page/trade/tabbar.dart';
import 'package:egat_flutter/screens/session.dart';
import 'package:egat_flutter/screens/widgets/loading_dialog.dart';
import 'package:egat_flutter/screens/widgets/show_exception.dart';
import 'package:egat_flutter/screens/widgets/show_success_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
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
  int _groupValue = 0;
  List<BilateralBuyTile> _bilateralTileList = [];
  List<BilateralBuyTile> _initBilateralTileList = [];
  List<BilateralBuyTile> _bilateralTileListOutput = [];
  // bool _isChecked = false;
  double _currentSliderValue = 9;
  Completer<GoogleMapController> _controller = Completer();
  // int selectedRadio = 0;

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
    // _date = "14:00-15:00, 21 August 2021";

    _getData();
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
    LoginSession loginModel = Provider.of<LoginSession>(context, listen: false);
    bool isSubmitable = _bilateralTileList.where(
          (element) {
            var isSeller = element.sellerId == loginModel.info!.userId;
            var isBuyer = (element.buyerId??'') == loginModel.info!.userId;
            return isSeller || isBuyer;
          },
        ).length ==
        0;
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
                      // padding: const EdgeInsets.symmetric(horizontal: 8),
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
                          Container(
                            height: constraints.maxHeight,
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: _bilateralTileList.length,
                              itemBuilder: (context, index) {
                                return Visibility(
                                  visible:
                                      (_bilateralTileList[index].isLongterm! || !_bilateralTileList[index].isBuyable!)
                                          ? false
                                          : true,
                                  child: _buildExpansionTile(
                                      "A",
                                      _bilateralTileList[index].name!,
                                      _bilateralTileList[index].date!,
                                      _bilateralTileList[index].energyToBuy!,
                                      _bilateralTileList[index].estimatedBuy!,
                                      _bilateralTileList[index].netEnergyPrice!,
                                      _bilateralTileList[index].energyTariff!,
                                      _bilateralTileList[index].energyPrice!,
                                      _bilateralTileList[index]
                                          .wheelingChargeTariff!,
                                      _bilateralTileList[index].wheelingCharge!,
                                      _bilateralTileList[index].tradingFee!,
                                      _bilateralTileList[index].vat!,
                                      index),
                                );
                              },
                            ),
                          )
                          // _buildExpansionTile(
                          //     "A", "Prosumer P02", "14:23, 20 Aug", 18.48, 4.45,4.00,3.15,12.60,1.15,4.60,0.08,1.20,18.48,4.62),
                          // _buildExpansionTile(
                          //     "B", "Prosumer P02", "14:23, 20 Aug", 18.48, 4.45,4.00,3.15,12.60,1.15,4.60,0.08,1.20,18.48,4.62),
                        ],
                      ),
                    ),
                  ),
                ),
                BottomButton(
                    onAction: isSubmitable ? _onSubmitPressed : null,
                    actionLabel: Text("Submit"))
              ]);
        },
      ),
    );
  }

  Widget _buildMap(BuildContext context) {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: CameraPosition(target: LatLng(101, 202), zoom: 1),
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
    );
  }

  Widget _headerTile(String position, String title, String date,
      double energyToBuy, double estimatedBuy, double netEstimated, int index) {
    var dateFormat = DateFormat('HH:mm, dd MMM');
    return SizedBox(
      height: 62,
      child: Row(
        children: [
          Radio<int>(
              value: index,
              groupValue: _groupValue,
              onChanged: (val) {
                setState(() {
                  _groupValue = val!;
                });
              }),
          Expanded(
            child: Container(
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
                          style: TextStyle(fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          dateFormat.format(DateTime.parse(date)),
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
                        EdgeInsets.only(top: 12, bottom: 12, left: 0, right: 0),
                    child: Column(
                      children: [
                        Text(
                          energyToBuy.toStringAsFixed(2),
                          style: TextStyle(fontSize: 14),
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
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(
                          top: 12, bottom: 12, left: 0, right: 0),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                overflow: TextOverflow.ellipsis,
                                text: TextSpan(
                                  style: TextStyle(fontSize: 10),
                                  children: <TextSpan>[
                                    TextSpan(text: "Estimated buy "),
                                    // TextSpan(text: estimated.toString()),
                                    // TextSpan(text: " THB"),
                                  ],
                                ),
                              ),
                              RichText(
                                overflow: TextOverflow.ellipsis,
                                text: TextSpan(
                                  style: TextStyle(fontSize: 8),
                                  children: <TextSpan>[
                                    TextSpan(text: "NET energy price "),
                                    // TextSpan(text: price.toString()),
                                    // TextSpan(text: " THB/kWh"),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                overflow: TextOverflow.ellipsis,
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: estimatedBuy.toStringAsFixed(2),
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    TextSpan(
                                        text: " THB",
                                        style: TextStyle(fontSize: 8)),
                                  ],
                                ),
                              ),
                              RichText(
                                overflow: TextOverflow.ellipsis,
                                text: TextSpan(
                                  style: TextStyle(fontSize: 10),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: netEstimated.toStringAsFixed(2),
                                        style: TextStyle(fontSize: 12)),
                                    TextSpan(
                                        text: "\nTHB/kWh",
                                        style: TextStyle(fontSize: 8)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildExpansionTile(
      String position,
      String title,
      String date,
      double energyToBuy,
      double estimatedBuy,
      double netEstimated,  
      double energyTariff,
      double energyPrice,
      double wheelingChargeTariff,
      double wheelingCharge,
      double tradingFee,
      double vat,
      int index) {
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
            title: _headerTile(position, title, date, energyToBuy, estimatedBuy,
                netEstimated, index),
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
                                energyToBuy.toStringAsFixed(2),
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
                              "Energy tariff",
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
                                energyTariff.toStringAsFixed(2),
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
                              "Energy price",
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
                                energyPrice.toStringAsFixed(2),
                                style: TextStyle(fontSize: 12),
                              ),
                              Text(
                                " THB",
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
                                wheelingChargeTariff.toStringAsFixed(2),
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
                                wheelingCharge.toStringAsFixed(2),
                                style: TextStyle(fontSize: 12),
                              ),
                              Text(
                                " THB",
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
                                tradingFee.toStringAsFixed(2),
                                style: TextStyle(fontSize: 12),
                              ),
                              Text(
                                " THB",
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
                                vat.toStringAsFixed(2),
                                style: TextStyle(fontSize: 12),
                              ),
                              Text(
                                " THB",
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
                                estimatedBuy.toStringAsFixed(2),
                                style: TextStyle(fontSize: 12),
                              ),
                              Text(
                                " THB",
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
                                netEstimated.toStringAsFixed(2),
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
    var dateFormat = DateFormat('dd MMMM yyyy');
    var startDate = DateTime.parse(_date).toLocal();
    var endDate = DateTime.parse(_date).toLocal().add(new Duration(hours: 1));
    var startHour = DateFormat('HH').format(startDate);
    var endHour = DateFormat('HH').format(endDate);
    String displayDate = startHour.toString() +
        ":00-" +
        endHour.toString() +
        ":00, " +
        dateFormat.format(DateTime.parse(_date));
    return Row(children: [
      RichText(
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        text: TextSpan(
          text: displayDate,
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,

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

  void showAlertDialog(BuildContext context) {
    var dateFormat = DateFormat('dd MMM');
    var startDate =
        DateTime.parse(_bilateralTileList[_groupValue].date!).toLocal();
    var endDate = DateTime.parse(_bilateralTileList[_groupValue].date!)
        .toLocal()
        .add(new Duration(hours: 1));
    var startHour = DateFormat('HH').format(startDate);
    var endHour = DateFormat('HH').format(endDate);
    String displayTime =
        startHour.toString() + ":00-" + endHour.toString() + ":00";
    String displayDate = dateFormat.format(
        DateTime.parse(_bilateralTileList[_groupValue].date!).toLocal());
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Short term Bilateral",
                  style: TextStyle(color: primaryColor, fontSize: 24),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Choose to buy",
                  style: TextStyle(color: redColor, fontSize: 18),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(5),
                  width: MediaQuery.of(context).size.width / 1.5,
                  height: MediaQuery.of(context).size.width / 3.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey,
                  ),
                  child: SingleChildScrollView(
                    child: Container(
                      child: new Text(
                        "${_bilateralTileList[_groupValue].name.toString()} Energy ${_bilateralTileList[_groupValue].energyToBuy.toString()} KWh\n${displayTime}, ${displayDate}",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: blackColor),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Estimated buy"),
                          Text("Net energy price"),
                        ],
                      ),
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              "${_bilateralTileList[_groupValue].estimatedBuy!.toStringAsFixed(2)} THB"),
                          Text(
                              "${_bilateralTileList[_groupValue].netEnergyPrice!.toStringAsFixed(2)} THB/kWh"),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.grey[800],
            actionsAlignment: MainAxisAlignment.spaceEvenly,
            actions: [
              FlatButton(
                  onPressed: () {
                    _onAgreePressed();
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Text(
                        "Agree",
                        style: TextStyle(color: blackColor),
                      ),
                    ),
                  )),
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: greyColor,
                        borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: blackColor),
                      ),
                    ),
                  )),
            ],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          );
        });
  }

  void _getData() async {
    BilateralBuy model = Provider.of<BilateralBuy>(context, listen: false);
    setState(() {
      _bilateralTileList = model.info.bilateralTileList!;
      _initBilateralTileList = model.info.bilateralTileList!;
      // _radioValues = List<int>.filled(_bilateralTileList.length, 1);
      _date = model.info.date!;
    });
  }

  Future<bool> _onWillPop() async {
    BilateralBuy model = Provider.of<BilateralBuy>(context, listen: false);
    model.setPageBack();
    return false;
  }

  void _onLongTermBilateralPressed() {
    //Navigate

    BilateralLongTermBuy bilateralLongTermBuy =
        Provider.of<BilateralLongTermBuy>(context, listen: false);
    BilateralBuy model = Provider.of<BilateralBuy>(context, listen: false);
    bilateralLongTermBuy.info.date = model.info.date;
    model.setPageBilateralLongTermBuy();
  }

  void _onSubmitPressed() {
    print("submit");
    // List<BilateralBuyTile> _bilateralTileList = [];
    int i = 0;

    setState(() {
      _bilateralTileListOutput = [];
    });
    // for (var _bilateral in _bilateralTileList) {
    //   if (_radioValues[i] == true) {
    //     // _bilateralTileList.add(_bilateral);
    //     setState(() {
    //       _bilateralTileListOutput.add(_bilateral);
    //     });
    //   }
    //   i++;
    // }

    // setState(() {
    //   _bilateralTileListOutput = _bilateralTileList;
    // });

    //Navigate
    showAlertDialog(context);
    // BilateralBuy model = Provider.of<BilateralBuy>(context, listen: false);
    // model.setPageBilateralTrade();
  }

  void _onAgreePressed() async {
    BilateralBuy model = Provider.of<BilateralBuy>(context, listen: false);
    bool response = false;
    await showLoading();
    try {
      response = await model
          .bilateralShortTermBuy(_bilateralTileList[_groupValue].id!);
    } catch (e) {
      showException(context, e.toString());
    } finally {
      await hideLoading();
    }
    if (response == true) {
      model.setPageBilateralTrade();
      showSuccessSnackBar(context, "ทำรายการสำเร็จ");
    } else {
      //TODO
      showException(context, "ไม่สามารถทำรายการได้");
    }
  }
}
