import 'dart:math';

import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/screens/forgot_password/widgets/forgot_password_cancellation_dialog.dart';
import 'package:egat_flutter/screens/page/api/model/PoolMarketReferencesResponse.dart';
import 'package:egat_flutter/screens/page/api/model/PoolMarketTradingFeeRequest.dart';
import 'package:egat_flutter/screens/page/api/model/PoolMarketTradingFeeResponse.dart';
import 'package:egat_flutter/screens/page/widgets/page_appbar.dart';
import 'package:egat_flutter/screens/pages/main/home/buysell/pool/apis/models/TransactionSubmitItem.dart';
import 'package:egat_flutter/screens/pages/main/home/buysell/pool/apis/pool_api.dart';
import 'package:egat_flutter/screens/session.dart';
import 'package:egat_flutter/screens/widgets/pin_input_blocker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import 'controllers/transaction_item_controller.dart';

class PoolMarketBuyScreen extends StatelessWidget {
  final List<TransactionSubmitItem> requestItems;

  const PoolMarketBuyScreen({
    Key? key,
    required this.requestItems,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PageAppbar(firstTitle: 'Pool Market', secondTitle: 'Trade'),
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
    return FutureBuilder<PoolMarketReferencesResponse>(
      future: _loadData(context),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return PoolBuyScreenBody(
            requestItems: requestItems,
            tradingFee: snapshot.data!,
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

  Future<PoolMarketReferencesResponse> _loadData(BuildContext context) async {
    final loginSession = Provider.of<LoginSession>(context);

    if (loginSession.info == null) {
      logger.log(Level.debug, 'loginSession.info is null');
      throw Exception('LoginSession is not provided.');
    }

    return await poolApi.getPoolMarketReferences(
      requestItems[0].date.toUtc().toIso8601String(),
      loginSession.info!.accessToken,
    );
  }
}

class PoolBuyScreenBody extends StatefulWidget {
  final List<TransactionSubmitItem> requestItems;
  final PoolMarketReferencesResponse tradingFee;

  const PoolBuyScreenBody({
    Key? key,
    required this.requestItems,
    required this.tradingFee,
  }) : super(key: key);

  @override
  _PoolBuyScreenBodyState createState() => _PoolBuyScreenBodyState();
}

class _SummarySectionState extends State<_SummarySection> {
  double get _estimatedBuy =>
      _energyPrice + _wheelingCharge + _tradingFee + _vat;
  double get _estimateNetPrice =>
      _energyToBuy == 0 ? 0 : _estimatedBuy / _energyToBuy;

  double _energyToBuy = 0;
  double _energyTariff = 0;
  double get _energyPrice => _energyToBuy * _energyTariff;
  double get _wheelingChargeTariff =>
      widget.tradingFee.wheelingChargeTariff ?? 0;
  double get _wheelingCharge => _wheelingChargeTariff * _energyToBuy;
  double get _tradingFee => (widget.tradingFee.tradingFee ?? 0) * _energyToBuy;
  double get _vat => (_energyPrice + _wheelingCharge + _tradingFee) * 0.07;

  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        AnimatedSize(
          duration: Duration(milliseconds: 150),
          child: SizedBox(
            height: _isExpanded ? null : 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  _SummaryValue(
                    title: 'Energy to buy',
                    value: _energyToBuy,
                    unit: 'kWh',
                    titleFontSize: 15,
                    valueFontSize: 15,
                    valueColor: Colors.white,
                  ),
                  _SummaryValue(
                    title: 'Energy tariff ',
                    value: _energyTariff,
                    unit: 'THB/kWh',
                    titleFontSize: 12,
                    valueFontSize: 12,
                    valueColor: Colors.white,
                  ),
                  _SummaryValue(
                    title: 'Energy price',
                    value: _energyPrice,
                    unit: 'THB',
                    titleFontSize: 15,
                    valueFontSize: 15,
                    valueColor: Colors.white,
                  ),
                  _SummaryValue(
                    title: 'Wheeling charge Tariff',
                    value: _wheelingChargeTariff,
                    unit: 'THB/kWh',
                    titleFontSize: 12,
                    valueFontSize: 12,
                    valueColor: Colors.white,
                  ),
                  _SummaryValue(
                    title: 'Wheeling charge',
                    value: _wheelingCharge,
                    unit: 'THB',
                    titleFontSize: 15,
                    valueFontSize: 15,
                    valueColor: Colors.white,
                  ),
                  _SummaryValue(
                    title: 'Trading fee',
                    value: _tradingFee,
                    unit: 'THB',
                    titleFontSize: 12,
                    valueFontSize: 12,
                    valueColor: Colors.white,
                  ),
                  _SummaryValue(
                    title: 'Vat (7%)',
                    value: _vat,
                    unit: 'THB',
                    titleFontSize: 12,
                    valueFontSize: 12,
                    valueColor: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: _SummaryValue(
                title: 'Estimated Buy',
                value: _estimatedBuy,
                unit: 'THB',
                titleFontSize: 15,
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _toggleExpandedState,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: AnimatedRotation(
                  turns: _isExpanded ? 0.5 : 0,
                  duration: Duration(milliseconds: 150),
                  child: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
              ),
            ),
          ],
        ),
        _SummaryValue(
          title: 'Estimate Net Price',
          value: _estimateNetPrice,
          unit: 'THB/kWh',
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

    _energyToBuy = 0;
    _energyTariff = 0;

    for (var item in selectedItems) {
      _energyToBuy += item.amount;
      _energyTariff += item.price;
    }
  }

  void _toggleExpandedState() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }
}

class _PoolBuyScreenBodyState extends State<PoolBuyScreenBody> {
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
        SizedBox(height: 12),
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
            tradingFee: widget.tradingFee,
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
      isSubmitable = true;
    }

    _transactionItemController.addListener(_onTransactionItemChange);
  }

  void _onSubmit() async {
    bool? isPassed = await PinInputBlocker.pushTo(context);
    if (isPassed != true) {
      showException(context, 'PIN is required!');
      return;
    }

    showLoading();
    try {
      final loginSession = Provider.of<LoginSession>(context, listen: false);

      if (loginSession.info == null) {
        logger.log(Level.debug, 'loginSession.info is null');
        throw Exception('LoginSession is not provided.');
      }

      var accessToken = loginSession.info!.accessToken;

      var date = widget.requestItems.first.date;
      var energy = _transactionItemController.selectedItems.map((item) {
        return item.amount;
      }).reduce((value, element) => value + element);
      var price = _transactionItemController.selectedItems.map((item) {
        return item.price;
      }).reduce((value, element) => value + element);

      await poolApi.poolMarketShortTermBuy(
          date.toUtc().toIso8601String(), energy, price, accessToken);
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
        isSubmitable = true;
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
              'Bid to Buy',
              style: TextStyle(fontSize: 20, color: Color(0xFFF6645A)),
            ),
          ],
        ),
      ],
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final Function()? onPressed;
  final bool isSubmitable;

  const _SubmitButton({
    Key? key,
    this.onPressed,
    this.isSubmitable = true,
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
          onPressed: isSubmitable ? onPressed : null,
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
  final PoolMarketReferencesResponse tradingFee;

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
  final double valueFontSize;
  final Color valueColor;

  const _SummaryValue({
    Key? key,
    required this.title,
    required this.value,
    required this.unit,
    required this.titleFontSize,
    this.valueFontSize = 20,
    this.valueColor = const Color(0xFFF6645A),
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
                      style: TextStyle(
                        color: valueColor,
                        fontSize: valueFontSize,
                      ),
                    ),
                  ),
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 60),
                  child: Text(
                    unit,
                    style: TextStyle(
                      fontSize: valueFontSize,
                    ),
                  ),
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
  final bool defaultIsExpanded;

  final double defaultEnergyToSale;
  final double defaultOfferToSellPrice;

  final TransactionItemController<TransactionSubmitItem> controller;

  const _TransactionItem({
    required Key? key,
    required this.date,
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
            _buildHeader(),
            SizedBox(
              height: _isExpanded ? null : 0,
              child: _buildContent(context),
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

    energyToSaleTextController = TextEditingController(
      text: _energyToSale.toStringAsFixed(2),
    );
    energyToSaleTextController?.addListener(_onTextEnergyToSaleChange);

    offerToSalePriceTextController = TextEditingController(
      text: _offerToSellPrice.toStringAsFixed(2),
    );
    offerToSalePriceTextController?.addListener(_onTextOfferToSellPriceChanged);

    widget.controller.selectItem(_ownerKey, _submitItem, notify: false);
    widget.controller.addListener(_onControllerChange);
  }

  void switchExpandedState() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _TransactionInput(
          title: 'Energy to Buy',
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
          unit: 'kWh',
          controller: offerToSalePriceTextController,
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildHeader() {
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
              SizedBox(height: 50, width: 15),
              Text(
                'Date: $dateString, Period: $startTimeString-$endTimeString',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            ],
          ),
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
