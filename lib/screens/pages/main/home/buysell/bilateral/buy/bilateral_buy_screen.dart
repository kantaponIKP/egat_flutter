import 'dart:async';

import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/screens/forgot_password/widgets/forgot_password_cancellation_dialog.dart';
import 'package:egat_flutter/screens/page/trade/bottom_button.dart';
import 'package:egat_flutter/screens/page/widgets/page_appbar.dart';
import '../apis/models/BilateralBuyItem.dart';
import 'package:egat_flutter/screens/pages/main/home/buysell/bilateral/apis/models/TransactionSubmitItem.dart';
import '../apis/bilateral_api.dart';
import 'package:egat_flutter/screens/session.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'short_term/bilateral_short_term_sell_page.dart';

class BilateralBuyScreen extends StatefulWidget {
  final DateTime date;

  const BilateralBuyScreen({
    Key? key,
    required this.date,
  }) : super(key: key);

  @override
  _BilateralBuyScreenState createState() => _BilateralBuyScreenState();
}

enum _OfferOrderType {
  PRICE,
  ENERGY,
}

enum _OfferOrderDirection {
  ASC,
  DESC,
}

class _OfferOrder {
  final _OfferOrderType type;
  final _OfferOrderDirection direction;

  const _OfferOrder(this.type, this.direction);

  operator ==(Object b) {
    if (b is _OfferOrder) {
      return type == b.type && direction == b.direction;
    }

    return false;
  }

  @override
  int get hashCode => Object.hash(type, direction);
}

class _BilateralBuyScreenState extends State<BilateralBuyScreen> {
  _OfferOrder _selectedOrder =
      const _OfferOrder(_OfferOrderType.PRICE, _OfferOrderDirection.DESC);

  Set<BilateralBuyItem> _selectedItems = Set();

  Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageAppbar(firstTitle: "Bilateral", secondTitle: "Buy"),
      body: SafeArea(
        child: FutureBuilder<List<BilateralBuyItem>>(
          future: _getData(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return _buildBody(context, snapshot.data!);
          },
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, List<BilateralBuyItem> items) {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [
            Color(0xFF303030),
            Colors.black,
          ],
        ),
      ),
      child: _buildAction(context, items),
    );
  }

  Padding _buildAction(
    BuildContext context,
    List<BilateralBuyItem> _bilateralItemList,
  ) {
    LoginSession loginModel = Provider.of<LoginSession>(context);

    final boughtItems = _bilateralItemList.where(
      (element) {
        var isSeller = element.sellerId == loginModel.info!.userId;
        var isBuyer = (element.buyerId ?? '') == loginModel.info!.userId;
        return isSeller || isBuyer;
      },
    );

    bool isSubmitable = boughtItems.length == 0;

    if (_selectedOrder.type == _OfferOrderType.PRICE) {
      _bilateralItemList.sort(
        (a, b) {
          if (_selectedOrder.direction == _OfferOrderDirection.ASC) {
            return a.energyPrice.compareTo(b.energyPrice);
          } else {
            return b.energyPrice.compareTo(a.energyPrice);
          }
        },
      );
    } else {
      _bilateralItemList.sort(
        (a, b) {
          if (_selectedOrder.direction == _OfferOrderDirection.ASC) {
            return a.netEnergyPrice.compareTo(b.netEnergyPrice);
          } else {
            return b.netEnergyPrice.compareTo(a.netEnergyPrice);
          }
        },
      );
    }

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
                        _HeaderSection(),
                        _DateSection(date: widget.date),
                        SizedBox(height: 12),
                        SizedBox(
                          height: 170,
                          child: _buildMap(context),
                        ),
                        SizedBox(height: 12),
                        _SelectionSection(
                          selectedOrder: _selectedOrder,
                          onOrderChanged: (newOrder) => {
                            setState(() {
                              _selectedOrder = newOrder;
                            })
                          },
                        ),
                        Container(
                          height: constraints.maxHeight,
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: _bilateralItemList.length,
                            itemBuilder: (context, index) {
                              return Visibility(
                                visible: (_bilateralItemList[index].isLongterm)
                                    ? false
                                    : true,
                                child: _BuyItemCard(
                                  index: index,
                                  item: _bilateralItemList[index],
                                  isChecked: _selectedItems.contains(
                                    _bilateralItemList[index],
                                  ),
                                  onTap: () => _onItemTap(
                                    _bilateralItemList[index],
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              BottomButton(
                onAction: isSubmitable ? _onPlaceOrderPressed : null,
                actionLabel: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    "Place Order",
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ],
          );
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

  void _onPlaceOrderPressed() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BilateralShortTermSellPage(
          requestItems: [
            TransactionSubmitItem(date: widget.date, amount: 1, price: 3)
          ],
        ),
      ),
    );

    Navigator.pop(context);
  }

  Future<List<BilateralBuyItem>> _getData() async {
    final loginSession = Provider.of<LoginSession>(context, listen: false);

    if (loginSession.info == null) {
      showException(context, "No login session provided");
      throw Exception("No login session provided");
    }

    final accessToken = loginSession.info!.accessToken;

    var data = await bilateralApi.getBilateralShortTermBuyInfo(
      requestDate: widget.date,
      accessToken: accessToken,
    );

    return data.bilateralList;
  }

  _onItemTap(BilateralBuyItem buyItem) {
    setState(() {
      if (_selectedItems.contains(buyItem)) {
        _selectedItems.remove(buyItem);
      } else {
        _selectedItems.add(buyItem);
      }
    });
  }
}

class _SelectionSection extends StatelessWidget {
  final List<_OfferOrder> offerItems = const [
    const _OfferOrder(_OfferOrderType.PRICE, _OfferOrderDirection.ASC),
    const _OfferOrder(_OfferOrderType.PRICE, _OfferOrderDirection.DESC),
    const _OfferOrder(_OfferOrderType.ENERGY, _OfferOrderDirection.ASC),
    const _OfferOrder(_OfferOrderType.ENERGY, _OfferOrderDirection.DESC),
  ];

  final _OfferOrder selectedOrder;
  final Function(_OfferOrder)? onOrderChanged;

  const _SelectionSection({
    Key? key,
    required this.selectedOrder,
    this.onOrderChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
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
                      fontWeight: FontWeight.w300,
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
              child: DropdownButton<_OfferOrder>(
                value: selectedOrder,
                icon: Icon(Icons.arrow_drop_down_rounded),
                iconSize: 20,
                iconEnabledColor: backgroundColor,
                dropdownColor: primaryColor,
                style: TextStyle(fontSize: 16, color: backgroundColor),
                alignment: Alignment.center,
                borderRadius: BorderRadius.circular(20),
                onChanged: onOrderChanged != null
                    ? (_OfferOrder? newValue) {
                        if (newValue != null) {
                          onOrderChanged?.call(newValue);
                        }
                      }
                    : null,
                items: offerItems.map((_OfferOrder item) {
                  final direactionName;
                  switch (item.direction) {
                    case _OfferOrderDirection.ASC:
                      direactionName = "Lowest";
                      break;
                    case _OfferOrderDirection.DESC:
                      direactionName = "Highest";
                      break;
                  }

                  final propertyName;
                  switch (item.type) {
                    case _OfferOrderType.ENERGY:
                      propertyName = "Energy";
                      break;
                    case _OfferOrderType.PRICE:
                      propertyName = "Price";
                      break;
                  }

                  return DropdownMenuItem<_OfferOrder>(
                    value: item,
                    child: Text(
                      "$direactionName $propertyName",
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                      ),
                    ),
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
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection({Key? key}) : super(key: key);

  onLongTermPressed() {}

  @override
  Widget build(BuildContext context) {
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
              Text("Short term Bilateral",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w200)),
            ],
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: onLongTermPressed,
              child: Row(
                children: [
                  Icon(Icons.refresh),
                  RichText(
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: "Long term Bilateral",
                      style: TextStyle(
                        color: blackColor,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ],
              ),
              style: ElevatedButton.styleFrom(elevation: 0),
            ),
          ],
        ),
      ],
    );
  }
}

class _DateSection extends StatelessWidget {
  const _DateSection({
    Key? key,
    required this.date,
  }) : super(key: key);

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    var dateFormat = DateFormat('dd MMMM yyyy');
    var hourFormat = DateFormat('HH:mm');

    var startDate = date;
    var endDate = startDate.add(new Duration(hours: 1));

    var startDateStartHour = DateTime(
      startDate.year,
      startDate.month,
      startDate.day,
      startDate.hour,
    ).toLocal();
    var endDateStartHour = DateTime(
      endDate.year,
      endDate.month,
      endDate.day,
      endDate.hour,
    ).toLocal();

    var startHour = hourFormat.format(startDateStartHour);
    var endHour = hourFormat.format(endDateStartHour);

    String displayDate = "$startHour-$endHour, ${dateFormat.format(startDate)}";

    return Row(
      children: [
        RichText(
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          text: TextSpan(
            text: displayDate,
            style: TextStyle(
              color: textColor,
              fontSize: 20,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ],
    );
  }
}

class _BuyItemCard extends StatelessWidget {
  final BilateralBuyItem item;
  final int index;
  final Function()? onTap;
  final bool isChecked;

  const _BuyItemCard({
    Key? key,
    required this.item,
    required this.index,
    required this.isChecked,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var dateFormat = DateFormat('HH:mm, dd MMM');

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
            title: _headerTile(
              "A",
              item.name,
              dateFormat.format(item.date),
              item.energyToBuy,
              item.estimatedBuy,
              item.netEnergyPrice,
              index,
            ),
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
                                item.energyToBuy.toStringAsFixed(2),
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
                                item.energyTariff.toStringAsFixed(2),
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
                                item.energyPrice.toStringAsFixed(2),
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
                                item.wheelingChargeTariff.toStringAsFixed(2),
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
                                item.wheelingCharge.toStringAsFixed(2),
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
                                item.tradingFee.toStringAsFixed(2),
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
                                item.vat.toStringAsFixed(2),
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
                                item.estimatedBuy.toStringAsFixed(2),
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
                                item.netEnergyPrice.toStringAsFixed(2),
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

  Widget _headerTile(String position, String title, String date,
      double energyToBuy, double estimatedBuy, double netEstimated, int index) {
    var dateFormat = DateFormat('HH:mm, dd MMM');
    return SizedBox(
      height: 62,
      child: Row(
        children: [
          // Radio<int>(
          //   value: index,
          //   groupValue: _groupValue,
          //   onChanged: (val) {
          //     setState(() {
          //       _groupValue = val!;
          //     });
          //   },
          // ),
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
}

_convertIndexToAlphabatical(int index) {
  if (index <= 0) {
    return '';
  }

  String alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  return _convertIndexToAlphabatical(index ~/ 24) + alphabet[index % 24];
}
