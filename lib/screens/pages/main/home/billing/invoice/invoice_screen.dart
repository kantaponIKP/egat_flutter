import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/i18n/app_localizations.dart';
import 'package:egat_flutter/screens/forgot_password/widgets/forgot_password_cancellation_dialog.dart';
import 'package:egat_flutter/screens/page/widgets/logo_appbar.dart';
import 'package:egat_flutter/screens/session.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../apis/billing_api.dart';
import '../apis/models/GetInvoiceResponse.dart';

class InvoiceScreen extends StatelessWidget {
  final DateTime month;

  const InvoiceScreen({
    Key? key,
    required this.month,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LogoAppbar(),
      body: _buildBackground(context),
    );
  }

  _buildBackground(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [
            Color(0xFF303030),
            Colors.black,
          ],
        ),
      ),
      child: _buildBody(context),
    );
  }

  _buildBody(BuildContext context) {
    return FutureBuilder<GetInvoiceResponse?>(
        initialData: null,
        future: _getData(context),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 16, bottom: 32, left: 8),
                      child: _buildContent(context, snapshot.data!),
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.error != null) {
            return Center(
              child: Text('Error ${snapshot.error.toString()}'),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  _buildContent(BuildContext context, GetInvoiceResponse data) {
    final toDateFormat = DateFormat(
      'MMMM yyyy',
      AppLocalizations.of(context).getLocale().toString(),
    );
    final toDate = toDateFormat.format(data.issueDate);

    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Previous Invoice',
            style: TextStyle(
              fontSize: 25,
              color: primaryColor,
            ),
          ),
          Text('$toDate', style: TextStyle(fontSize: 13)),
          SizedBox(height: 20),
          _InvoiceInfo(data: data),
          SizedBox(height: 20),
          _ElectricUserInfo(data: data),
          SizedBox(height: 15),
          _MeterInfoSection(data: data),
          SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: _EnergyTradingPaymentSection(data: data),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 24),
            child: _EnergyGridPaymentSection(data: data),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 24),
            child: _EnergyWheelingChargePaymentSection(data: data),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, top: 24),
            child: _SummarySection(data: data),
          ),
        ],
      ),
    );
  }

  Future<GetInvoiceResponse?> _getData(BuildContext context) async {
    final loginSession = Provider.of<LoginSession>(context, listen: false);

    if (loginSession.info == null) {
      showException(context, "No login session provided.");
      return null;
    }

    final accessToken = loginSession.info!.accessToken;

    return await billingApi.fetchInvoice(
      accessToken: accessToken,
      month: month,
    );
  }
}

class _ElectricInfoHeader extends StatelessWidget {
  final String title;
  final String? secondaryTitle;
  final String? unit1;
  final String unit2;

  const _ElectricInfoHeader({
    Key? key,
    required this.title,
    this.secondaryTitle,
    this.unit1,
    required this.unit2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var title;
    if (secondaryTitle != null) {
      title = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(this.title, style: TextStyle(fontSize: 12)),
          SizedBox(height: 4),
          Text(this.secondaryTitle!, style: TextStyle(fontSize: 10)),
        ],
      );
    } else {
      title = Text(this.title, style: TextStyle(fontSize: 12));
    }

    return DefaultTextStyle(
      style: TextStyle(
        fontSize: 10,
        color: primaryColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          title,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: 50,
                ),
                child: unit1 != null ? Text(unit1!) : Container(),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: 50,
                ),
                child: Text(unit2),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ElectricInfoItem extends StatelessWidget {
  final String title;
  final String? secondaryTitle;
  final String? description;
  final double? value1;
  final double? value1String;
  final double value2;

  const _ElectricInfoItem({
    Key? key,
    required this.title,
    this.secondaryTitle,
    this.value1,
    required this.value2,
    this.description,
    this.value1String,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget value1Widget = Container();

    if (description != null) {
      value1Widget = Padding(
        padding: const EdgeInsets.only(right: 30),
        child: Text(description!),
      );
      value1Widget = ConstrainedBox(
        constraints: BoxConstraints(minWidth: 45),
        child: value1Widget,
      );
    } else if (value1 != null) {
      value1Widget = ConstrainedBox(
        constraints: BoxConstraints(minWidth: 50),
        child: Text('${value1!.toStringAsFixed(2)}'),
      );
    }

    var title;
    if (secondaryTitle != null) {
      title = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(this.title),
          SizedBox(height: 4),
          Text(secondaryTitle!),
        ],
      );
    } else {
      title = Text(this.title);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: DefaultTextStyle(
        style: TextStyle(
          fontSize: 9,
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            title,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                value1Widget,
                ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: 48,
                  ),
                  child: Text(value2.toStringAsFixed(2)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InvoiceInfo extends StatelessWidget {
  final GetInvoiceResponse data;

  const _InvoiceInfo({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var issueDateFormat = DateFormat(
      'dd/MMM/yyyy',
      AppLocalizations.of(context).getLocale().toString(),
    );
    var issueDateString = issueDateFormat.format(data.issueDate);

    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Invoice',
                style: TextStyle(fontSize: 10),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  "การไฟฟ้า ${data.providerName}",
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'ใบแจ้งค่าซื้อขายไฟฟ้า/บริการ',
                style: TextStyle(fontSize: 10),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  "$issueDateString",
                  style: TextStyle(fontSize: 10),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _MeterInfoSection extends StatelessWidget {
  final GetInvoiceResponse data;

  const _MeterInfoSection({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        direction: Axis.horizontal,
        spacing: 16,
        runSpacing: 16,
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          _MeterInfoGridItem(
            title: "บัญขีแสดงสัญญา",
            secondaryTitle: "(CA/Ref No.1)",
            value: data.meterCA,
          ),
          _MeterInfoGridItem(
            title: "รหัสเครื่องวัดฯ",
            secondaryTitle: "(Installation)",
            value: data.meterInstallationSerial,
          ),
          _MeterInfoGridItem(
            title: "เลขที่ใบแจ้งฯ",
            secondaryTitle: "(Invoice No./Ref No.2)",
            value: data.meterInvoiceNo,
          ),
          _MeterInfoGridItem(
            title: "ประเภท",
            secondaryTitle: "(Type)",
            value: data.meterType,
          ),
        ],
      ),
    );
  }
}

class _MeterInfoGridItem extends StatelessWidget {
  final String title;
  final String? secondaryTitle;
  final String value;

  const _MeterInfoGridItem({
    Key? key,
    required this.title,
    this.secondaryTitle,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          this.title,
          style: TextStyle(fontSize: 10, color: primaryColor),
        ),
        SizedBox(height: 2),
        Text(
          this.secondaryTitle ?? "",
          style: TextStyle(fontSize: 10, color: primaryColor),
        ),
        SizedBox(height: 8),
        Text(
          this.value,
          style: TextStyle(fontSize: 10),
        ),
      ],
    );
  }
}

class _ElectricUserInfo extends StatelessWidget {
  final GetInvoiceResponse data;

  const _ElectricUserInfo({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(
        fontSize: 10,
      ),
      child: Wrap(
        direction: Axis.horizontal,
        spacing: 16,
        runSpacing: 4,
        crossAxisAlignment: WrapCrossAlignment.end,
        alignment: WrapAlignment.spaceBetween,
        children: [
          Text('ชื่อผู้ใช้ไฟฟ้า (Name) : ${data.electricUserName}'),
          Text('Meter Name : ${data.meterName}'),
          Text('Meter Id : ${data.meterId}'),
        ],
      ),
    );
  }
}

class _EnergySectionBase extends StatefulWidget {
  final Widget title;
  final List<Widget> contents;

  _EnergySectionBase({
    required this.title,
    required this.contents,
    Key? key,
  }) : super(key: key);

  @override
  State<_EnergySectionBase> createState() => __EnergySectionBaseState();
}

class __EnergySectionBaseState extends State<_EnergySectionBase> {
  bool _expanded = false;

  _switchExpanded() {
    setState(() {
      _expanded = !_expanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: _switchExpanded,
          behavior: HitTestBehavior.opaque,
          child: Column(
            children: [
              widget.title,
              AnimatedRotation(
                turns: _expanded ? 0.5 : 0,
                duration: Duration(
                  milliseconds: 200,
                ),
                child: Icon(
                  Icons.keyboard_arrow_down,
                  size: 24,
                ),
              )
            ],
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          clipBehavior: Clip.hardEdge,
          child: SizedBox(
            height: _expanded ? null : 0,
            child: Column(
              children: [
                SizedBox(height: 8),
                ...widget.contents,
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _EnergyGridPaymentSection extends StatelessWidget {
  final GetInvoiceResponse data;

  const _EnergyGridPaymentSection({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _EnergySectionBase(
      title: _ElectricInfoHeader(
        title: 'รายละเอียดค่าซื้อไฟฟ้าจาก Grid (Grid Used)',
        unit1: 'kWh',
        unit2: 'Baht',
      ),
      contents: [
        _ElectricInfoItem(
          title: 'ค่าพลังงานไฟฟ้า (Grid Used)',
          value1: data.gridUsedUnit,
          value2: data.gridUsedBaht,
        ),
        _ElectricInfoItem(
          title: 'ค่าบริการ',
          description: 'Baht/Month',
          value2: data.gridServiceCharge,
        ),
        _ElectricInfoItem(
          title: 'ค่าไฟฟ้าผันแปร (Ft)',
          description: 'Baht/kWh',
          value2: data.gridFt,
        ),
        _ElectricInfoItem(
          title: 'ส่วนลดค่าพลังงานไฟฟ้า',
          description: '%',
          value2: data.gridDiscount,
        ),
        _ElectricInfoItem(
          title: 'รวมค่าไฟฟ้าก่อนภาษีมูลค่าเพิ่ม',
          description: 'รวมค่าใช้บริการระบบโครงข่ายไฟฟ้า (Wheeling Charge)%',
          value2: data.gridNetWheelingChargeBeforeVat,
        ),
        _ElectricInfoItem(
          title: 'รวมค่าซื้อไฟฟ้าจาก Grid เดือนปัจจุบัน',
          value2: data.gridNetBought,
        ),
      ],
    );
  }
}

class _EnergyTradingPaymentSection extends StatelessWidget {
  final GetInvoiceResponse data;

  const _EnergyTradingPaymentSection({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _EnergySectionBase(
      title: _ElectricInfoHeader(
        title: 'รายละเอียดค่าซื้อขายพลังงานไฟฟ้า (Energy Trading Payment)',
        unit1: 'kWh',
        unit2: 'Baht',
      ),
      contents: [
        _ElectricInfoItem(
          title: 'Net Energy Buys',
          value1: data.netEnergyBuyUnit,
          value2: data.netEnergyBuyBaht,
        ),
        _ElectricInfoItem(
          title: 'Net Imbalance',
          value1: data.netImbalanceUnit,
          value2: data.netImbalanceBaht,
        ),
        _ElectricInfoItem(
          title: 'Net Buyer Imbalance+',
          value1: data.netBuyerImbalanceOverCommitUnit,
          value2: data.netBuyerImbalanceOverCommitBaht,
        ),
        _ElectricInfoItem(
          title: 'Net Buyer Imbalance-',
          value1: data.netBuyerImbalanceUnderCommitUnit,
          value2: data.netBuyerImbalanceUnderCommitBaht,
        ),
        _ElectricInfoItem(
          title: 'Net Seller Imbalance+',
          value1: data.netSellerImbalanceOverCommitUnit,
          value2: data.netSellerImbalanceOverCommitBaht,
        ),
        _ElectricInfoItem(
          title: 'Net Seller Imbalance-',
          value1: data.netSellerImbalanceUnderCommitUnit,
          value2: data.netSellerImbalanceUnderCommitBaht,
        ),
        _ElectricInfoItem(
          title: 'App Transaction Fees',
          description: 'รวมค่าใช้บริการระบบโครงข่ายไฟฟ้า (Wheeling Charge)%',
          value2: data.appTransactionFee,
        ),
        _ElectricInfoItem(
          title: 'Discount App Fees',
          value2: data.discountAppFee,
        ),
        _ElectricInfoItem(
          title: 'VAT',
          description: 'ภาษีมูลค่าเพิ่ม %',
          value2: data.vat,
        ),
        _ElectricInfoItem(
          title:
              'รวมค่าซื้อขายพลังงานไฟฟ้า (Net Energy Trading Payment) เดือนปัจจุบัน',
          value2: data.netEnergyTradingPayment,
        ),
      ],
    );
  }
}

class _EnergyWheelingChargePaymentSection extends StatelessWidget {
  final GetInvoiceResponse data;

  const _EnergyWheelingChargePaymentSection({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _EnergySectionBase(
      title: _ElectricInfoHeader(
        title: 'รายละเอียดค่าใช้บริการหรือการเชื่อมต่อระบบโครงข่ายไฟฟ้า',
        secondaryTitle: '(Wheeling Charge)',
        unit2: 'Baht',
      ),
      contents: [
        _ElectricInfoItem(
          title: 'ค่าบริการเสริมความมั่นคงของระบบไฟฟ้า (AS)',
          description: 'ส่วนลดค่าพลังงานไฟฟ้า Baht/kWh',
          value2: data.wheelingChargeAsServiceCharge,
        ),
        _ElectricInfoItem(
          title: 'ค่าบริการระบบส่งไฟฟ้า (T)',
          description: 'รวมค่าไฟฟ้าก่อนภาษีมูลค่าเพิ่ม Baht/kWh',
          value2: data.wheelingChargeTServiceCharge,
        ),
        _ElectricInfoItem(
          title: 'ค่าบริการระบบจำหน่ายไฟฟ้า (D)',
          description: 'VAT Baht/kWh',
          value2: data.wheelingChargeDServiceCharge,
        ),
        _ElectricInfoItem(
          title: 'ค่าใช้จ่ายในการส่งเสริมพลังงานทดแทน (RE)',
          description: 'รวมค่าซื้อไฟฟ้าจาก Grid Baht/kWh',
          value2: data.wheelingChargeReServiceCharge,
        ),
        _ElectricInfoItem(
          title: 'รวมค่าใช้บริการระบบโครงข่ายไฟฟ้า',
          secondaryTitle: '(Wheeling Charge)',
          description: 'ก่อนภาษีมูลค่าเพิ่ม',
          value2: data.wheelingChargeBeforeVat,
        ),
        _ElectricInfoItem(
          title: 'ภาษีมูลค่าเพิ่ม',
          description: 'รวมค่าใช้บริการระบบโครงข่ายไฟฟ้า (Wheeling Charge)%',
          value2: data.wheelingChargeVat,
        ),
        _ElectricInfoItem(
          title:
              'รวมค่าใช้บริการระบบโครงข่ายไฟฟ้า (Wheeling Charge) เดือนปัจจุบัน',
          value2: data.wheelingChargeNet,
        ),
      ],
    );
  }
}

class _SummarySection extends StatelessWidget {
  final GetInvoiceResponse data;

  const _SummarySection({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var toDateFormat = DateFormat(
      'MMMM yyyy',
      AppLocalizations.of(context).getLocale().toString(),
    );
    var toDate = toDateFormat.format(data.issueDate);

    return _SummaryValue(
      title: "Estimated Net Payment",
      secondaryTitle: "(as of $toDate)",
      value: data.estimateNetPayment.toStringAsFixed(2),
      unit: 'Baht',
    );
  }
}

class _SummaryValue extends StatelessWidget {
  final String title;
  final String secondaryTitle;
  final String value;
  final String unit;

  const _SummaryValue({
    Key? key,
    required this.title,
    required this.secondaryTitle,
    required this.value,
    required this.unit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(
        fontSize: 15,
      ),
      textAlign: TextAlign.left,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: title,
                      style: const TextStyle(fontSize: 15),
                    ),
                    const TextSpan(text: '\n'),
                    TextSpan(
                      text: secondaryTitle,
                      style: const TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(value, style: const TextStyle(fontSize: 35)),
              SizedBox(width: 8),
              SizedBox(
                height: 30,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(unit, style: const TextStyle(fontSize: 15)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
