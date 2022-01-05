import 'dart:math';

import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/screens/forgot_password/widgets/forgot_password_cancellation_dialog.dart';
import 'package:egat_flutter/screens/page/widgets/page_appbar.dart';
import 'package:egat_flutter/screens/session.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../../apis/bilateral_api.dart';
import '../../apis/models/BilateralTradingFeeResponse.dart';
import '../../apis/models/TransactionSubmitItem.dart';
import 'controllers/transaction_item_controller.dart';

// TODO: fix double action

class BilateralShortTermSellScreen extends StatelessWidget {
  final List<TransactionSubmitItem> requestItems;

  const BilateralShortTermSellScreen({
    Key? key,
    required this.requestItems,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PageAppbar(firstTitle: 'Bilateral', secondTitle: 'Trade'),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [
            Color(0xFF303030),
            Colors.black,
          ],
        ),
      ),
      child: _buildFuture(context),
    );
  }

  _buildFuture(BuildContext context) {
    return FutureBuilder<BilateralTradingFeeResponse>(
      future: _loadData(context),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return BilateralShortTermSellScreenBody(
            requestItems: requestItems,
            bilateralTradingFeeResponse: snapshot.data!,
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        } else {
          return _buildLoading();
        }
      },
    );
  }

  _buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Future<BilateralTradingFeeResponse> _loadData(BuildContext context) async {
    final loginSession = Provider.of<LoginSession>(context);

    if (loginSession.info == null) {
      logger.log(Level.debug, 'loginSession.info is null');
      throw Exception('LoginSession is not provided.');
    }

    final dateList = requestItems.map((e) => e.date).toList();
    return await bilateralApi.getBilateralTradingFee(
      dateList: dateList,
      accessToken: loginSession.info!.accessToken,
    );
  }
}

class BilateralShortTermSellScreenBody extends StatefulWidget {
  final List<TransactionSubmitItem> requestItems;
  final BilateralTradingFeeResponse bilateralTradingFeeResponse;

  const BilateralShortTermSellScreenBody({
    Key? key,
    required this.requestItems,
    required this.bilateralTradingFeeResponse,
  }) : super(key: key);

  @override
  _BilateralShortTermSellScreenBodyState createState() =>
      _BilateralShortTermSellScreenBodyState();
}

class _SummarySectionState extends State<_SummarySection> {
  double _tradingFee = 0;
  double _estimatedSales = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _SummaryValue(
          title: 'Trading Fee',
          value: _tradingFee,
          unit: 'THB',
          titleFontSize: 15,
        ),
        _SummaryValue(
          title: 'Estimated Sales',
          value: _estimatedSales,
          unit: 'THB',
          titleFontSize: 20,
        ),
      ],
    );
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChange);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _tradingFee = 0;
    _estimatedSales = 0;

    _updateValue();

    widget.controller.addListener(_onControllerChange);
  }

  _onControllerChange() {
    setState(() {
      _updateValue();
    });
  }

  void _updateValue() {
    final selectedItems = widget.controller.selectedItems;

    _tradingFee = 0;
    _estimatedSales = 0;

    for (var item in selectedItems) {
      var tradingFee = 0.0;
      final tradingFeeItem = widget.tradingFee.tradingFees.where((element) {
        var diff = element.settlementTime.difference(item.date);
        return diff.inHours == 0;
      }).toList();

      if (tradingFeeItem.length != 0) {
        tradingFee = tradingFeeItem.first.tradingFee;
      }

      _tradingFee += tradingFee * item.amount;
      _estimatedSales += item.amount * item.price;
    }

    _estimatedSales += _tradingFee;
  }
}

class _BilateralShortTermSellScreenBodyState
    extends State<BilateralShortTermSellScreenBody> {
  TransactionItemController<TransactionSubmitItem> _transactionItemController =
      TransactionItemController<TransactionSubmitItem>();

  bool isSubmitable = false;

  @override
  build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: _HeaderSection(),
        ),
        Expanded(
          child: _TransactionList(
            controller: _transactionItemController,
            items: widget.requestItems,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          child: _SummarySection(
            controller: _transactionItemController,
            tradingFee: widget.bilateralTradingFeeResponse,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            bottom: 16,
            left: 32,
            right: 32,
          ),
          child: _SubmitButton(
            onPressed: isSubmitable ? _onSubmit : null,
          ),
        ),
      ],
    );
  }

  void dispose() {
    _transactionItemController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _transactionItemController =
        TransactionItemController<TransactionSubmitItem>();

    final selectedItems = _transactionItemController.selectedItems;
    if (selectedItems.length > 0) {
      isSubmitable = true;
    } else {
      isSubmitable = false;
    }

    _transactionItemController.addListener(_onTransactionItemChange);
  }

  void _onSubmit() async {
    showLoading();
    try {
      final loginSession = Provider.of<LoginSession>(context, listen: false);

      if (loginSession.info == null) {
        logger.log(Level.debug, 'loginSession.info is null');
        throw Exception('LoginSession is not provided.');
      }

      await bilateralApi.bilateralShortTermSell(
        accessToken: loginSession.info!.accessToken,
        submitItems: _transactionItemController.selectedItems,
      );
    } catch (e) {
      showException(context, e.toString());
    } finally {
      hideLoading();
      Navigator.of(context).pop();
    }
  }

  void _onTransactionItemChange() {
    final selectedItems = _transactionItemController.selectedItems;

    setState(() {
      if (selectedItems.length > 0) {
        isSubmitable = true;
      } else {
        isSubmitable = false;
      }
    });
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Offer to Sell',
              style: TextStyle(fontSize: 20, color: Color(0xFF99FF75)),
            ),
            Text(
              'Short term Bilateral',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: primaryColor,
          ),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.more_time_rounded,
                  color: Colors.black,
                ),
                Text(
                  'Register to long term Bilateral',
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final Function()? onPressed;

  const _SubmitButton({
    Key? key,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SizedBox(
        width: constraints.maxWidth,
        child: TextButton(
          style: TextButton.styleFrom(
            primary: Colors.black,
            backgroundColor: onPressed != null ? primaryColor : greyColor,
          ),
          onPressed: onPressed,
          child: Text(
            'Submit',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w300,
              color: Colors.black,
            ),
          ),
        ),
      );
    });
  }
}

class _SummarySection extends StatefulWidget {
  final BilateralTradingFeeResponse tradingFee;

  final TransactionItemController<TransactionSubmitItem> controller;

  const _SummarySection({
    Key? key,
    required this.tradingFee,
    required this.controller,
  }) : super(key: key);

  @override
  _SummarySectionState createState() => _SummarySectionState();
}

class _SummaryValue extends StatelessWidget {
  final String title;
  final double value;
  final String unit;
  final double titleFontSize;

  const _SummaryValue({
    Key? key,
    required this.title,
    required this.value,
    required this.unit,
    required this.titleFontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DefaultTextStyle(
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w200,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: titleFontSize),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minWidth: 60),
                    child: Text(
                      value.toStringAsFixed(2),
                      textAlign: TextAlign.end,
                      style: TextStyle(color: primaryColor),
                    ),
                  ),
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 40),
                  child: Text(unit),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TransactionInput extends StatelessWidget {
  final String title;
  final String? secondaryTitle;
  final String unit;
  final Function(double)? onChanged;

  final TextEditingController? controller;

  const _TransactionInput({
    Key? key,
    required this.title,
    this.secondaryTitle,
    required this.unit,
    this.onChanged,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget titleWidget;
    if (secondaryTitle != null) {
      titleWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              color: Colors.white,
            ),
          ),
          Text(
            secondaryTitle!,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white,
            ),
          ),
        ],
      );
    } else {
      titleWidget = Text(title);
    }

    return Padding(
      padding: const EdgeInsets.only(left: 15, top: 12, bottom: 12),
      child: DefaultTextStyle(
        style: TextStyle(
          fontWeight: FontWeight.w300,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            titleWidget,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 80,
                  ),
                  child: TextFormField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.end,
                    onChanged: (value) {
                      if (onChanged != null) {
                        onChanged?.call(double.tryParse(value) ?? 0);
                      }
                    },
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      color: primaryColor,
                      fontSize: 15,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '0.00',
                      contentPadding:
                          const EdgeInsets.only(right: 4, bottom: 4),
                      isDense: true,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a valid value';
                      }

                      num? parsedValue = num.tryParse(value);

                      if (parsedValue == null) {
                        return 'Please enter a valid value';
                      }

                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: 90,
                    ),
                    child: Text(unit),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _TransactionItem extends StatefulWidget {
  final DateTime date;
  final bool defaultIsSelected;
  final bool defaultIsExpanded;

  final double defaultEnergyToSale;
  final double defaultOfferToSellPrice;

  final TransactionItemController<TransactionSubmitItem> controller;

  const _TransactionItem({
    required Key? key,
    required this.date,
    this.defaultIsSelected = false,
    this.defaultEnergyToSale = 0,
    this.defaultOfferToSellPrice = 0,
    this.defaultIsExpanded = true,
    required this.controller,
  }) : super(key: key);

  @override
  _TransactionItemState createState() => _TransactionItemState();
}

class _TransactionItemState extends State<_TransactionItem> {
  bool _isExpanded = true;

  double _energyToSale = 0;
  double _offerToSellPrice = 0;

  TextEditingController? energyToSaleTextController;

  TextEditingController? offerToSalePriceTextController;

  Object get _ownerKey => widget.key ?? this;

  TransactionSubmitItem get _submitItem => TransactionSubmitItem(
        amount: _energyToSale,
        price: _offerToSellPrice,
        date: widget.date,
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF292929),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: switchExpandedState,
              behavior: HitTestBehavior.translucent,
              child: _buildHeader(),
            ),
            AnimatedSize(
              duration: Duration(milliseconds: 150),
              clipBehavior: Clip.hardEdge,
              child: SizedBox(
                height: _isExpanded ? null : 0,
                child: _buildContent(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();

    widget.controller.removeListener(_onControllerChange);
    energyToSaleTextController?.removeListener(_onTextEnergyToSaleChange);
    offerToSalePriceTextController
        ?.removeListener(_onTextOfferToSellPriceChanged);
  }

  @override
  void initState() {
    super.initState();

    _energyToSale = widget.defaultEnergyToSale;
    _offerToSellPrice = widget.defaultOfferToSellPrice;
    _isExpanded = widget.defaultIsExpanded;

    if (widget.defaultIsSelected) {
      widget.controller.selectItem(_ownerKey, _submitItem, notify: false);
    }

    energyToSaleTextController = TextEditingController(
      text: _energyToSale.toStringAsFixed(2),
    );
    energyToSaleTextController?.addListener(_onTextEnergyToSaleChange);

    offerToSalePriceTextController = TextEditingController(
      text: _offerToSellPrice.toStringAsFixed(2),
    );
    offerToSalePriceTextController?.addListener(_onTextOfferToSellPriceChanged);

    widget.controller.addListener(_onControllerChange);
  }

  void switchExpandedState() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void switchSelectedState() {
    final isSelected = widget.controller.isItemSelected(_ownerKey);

    if (!isSelected) {
      widget.controller.selectItem(_ownerKey, _submitItem);
    } else {
      widget.controller.deselectItem(_ownerKey);
    }
  }

  _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _TransactionInput(
          title: 'Energy to Sale',
          unit: 'kWh',
          controller: energyToSaleTextController,
        ),
        SizedBox(height: 16),
        _TransactionSliderInput(
          unit: 'kWh',
          value: _energyToSale,
          onChange: _onEnergyToSalesSliderChange,
        ),
        _TransactionInput(
          title: 'Offer to Sell Price',
          secondaryTitle: 'Market price = THB 3.00',
          unit: 'THB/kWh',
          controller: offerToSalePriceTextController,
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildHeader() {
    final isSelected = widget.controller.isItemSelected(widget.key ?? this);

    final dateFormat = DateFormat('dd MMM yyyy');
    final timeFormat = DateFormat('HH:mm');

    final widgetTime = widget.date.toLocal();

    final startTime = DateTime(
      widgetTime.year,
      widgetTime.month,
      widgetTime.day,
      widgetTime.hour,
    );
    final endTime = startTime.add(const Duration(hours: 1));

    final dateString = dateFormat.format(widget.date);
    final startTimeString = timeFormat.format(startTime);
    final endTimeString = timeFormat.format(endTime);

    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Checkbox(
                value: isSelected,
                onChanged: (_) => switchSelectedState(),
              ),
              Text(
                'Date: $dateString, Period: $startTimeString-$endTimeString',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          AnimatedRotation(
            duration: Duration(milliseconds: 150),
            turns: _isExpanded ? 0.5 : 0,
            child: Icon(
              Icons.arrow_drop_down,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }

  void _notifyChangeToController() {
    if (widget.controller.isItemSelected(_ownerKey)) {
      widget.controller.selectItem(_ownerKey, _submitItem);
    }
  }

  _onControllerChange() {
    try {
      setState(() {
        widget.controller.isItemSelected(_ownerKey);
      });
    } catch (e) {
      print(e);
    }
  }

  void _onEnergyToSalesSliderChange(double value) {
    _energyToSale = value;

    if (energyToSaleTextController != null) {
      energyToSaleTextController!.value = TextEditingValue(
        text: _energyToSale.toStringAsFixed(2),
      );
    }

    _notifyChangeToController();
  }

  _onTextEnergyToSaleChange() {
    final value = double.tryParse(energyToSaleTextController!.value.text);

    if (value != null) {
      setState(() {
        _energyToSale = value;
        _notifyChangeToController();
      });
    }
  }

  _onTextOfferToSellPriceChanged() {
    final value = double.tryParse(offerToSalePriceTextController!.value.text);

    if (value != null) {
      setState(() {
        _offerToSellPrice = value;
        _notifyChangeToController();
      });
    }
  }
}

class _TransactionList extends StatelessWidget {
  final TransactionItemController<TransactionSubmitItem> controller;
  final List<TransactionSubmitItem> items;

  const _TransactionList({
    Key? key,
    required this.controller,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            for (var item in items.asMap().entries)
              _TransactionItem(
                key: Key('transaction-item-${item.key}'),
                date: item.value.date,
                defaultIsSelected: false,
                defaultEnergyToSale: item.value.amount,
                defaultOfferToSellPrice: item.value.price,
                controller: controller,
              ),
          ],
        ),
      ),
    );
  }
}

class _TransactionSliderInput extends StatelessWidget {
  final String unit;
  final double value;

  final void Function(double value)? onChange;

  const _TransactionSliderInput({
    Key? key,
    required this.unit,
    required this.value,
    this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var value = max(min(this.value, 10), 0);

    return SizedBox(
      height: 50,
      child: Stack(
        children: [
          Positioned(
            left: 16,
            top: 0,
            child: Center(
              child: Text(
                '0 $unit',
                style: TextStyle(
                  fontSize: 8,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
            right: 16,
            top: 0,
            child: Center(
              child: Text(
                '10 $unit',
                style: TextStyle(
                  fontSize: 8,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SliderTheme(
            data: SliderThemeData(
              thumbColor: primaryColor,
              activeTrackColor: primaryColor,
              inactiveTrackColor: primaryColor,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5),
              trackHeight: 2,
              valueIndicatorColor: primaryColor,
              valueIndicatorTextStyle: const TextStyle(
                color: Colors.black,
              ),
            ),
            child: Slider(
              value: value.toDouble(),
              min: 0,
              max: 10,
              divisions: 200,
              onChanged: onChange,
              label: '${value.toStringAsFixed(2)} $unit',
            ),
          ),
        ],
      ),
    );
  }
}
