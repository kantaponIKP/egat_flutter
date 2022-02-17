import '../models/settlement_report_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DatedSettlementReportDetail extends StatefulWidget {
  final ContractRole role;
  final SettlementResultType resultType;
  final MarketType marketType;
  final Widget date;
  final String? contractId;
  final bool defaultExpanded = true;
  final String? targetName;

  final List<DatedSettlementReportDetailBoxItem> items;

  const DatedSettlementReportDetail({
    Key? key,
    required this.role,
    required this.date,
    required this.resultType,
    required this.marketType,
    required this.items,
    this.contractId,
    this.targetName,
  }) : super(key: key);

  @override
  _DatedSettlementReportDetailState createState() =>
      _DatedSettlementReportDetailState();
}

class DatedSettlementReportDetailBoxItem {
  final String name;
  final String value;
  final double fontSize;
  final Color fontColor;

  const DatedSettlementReportDetailBoxItem({
    required this.name,
    required this.value,
    this.fontSize = 13,
    this.fontColor = Colors.black,
  });
}

class _ContentSection extends StatelessWidget {
  final List<DatedSettlementReportDetailBoxItem> items;
  final bool isExpanded = true;

  const _ContentSection({
    Key? key,
    required this.items,
    // required this.isExpanded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var lines = <Widget>[];

    for (var item in items) {
      lines.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  item.name,
                  style: TextStyle(
                    fontSize: item.fontSize,
                    color: item.fontColor,
                  ),
                ),
              ),
              SizedBox(width: 8),
              Text(
                item.value,
                style: TextStyle(
                  fontSize: item.fontSize,
                  color: item.fontColor,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return LayoutBuilder(builder: (context, constraints) {
      final double? height = isExpanded ? null : 0;

      return AnimatedSize(
        duration: Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        child: Container(
          height: height,
          decoration: BoxDecoration(color: Color(0xFFB4B4B4)),
          child: SizedBox(
            width: constraints.maxWidth,
            child: Padding(
              padding:
                  EdgeInsets.only(top: 10, bottom: 16, left: 16, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: lines,
              ),
            ),
          ),
        ),
      );
    });
  }
}

class _DatedSettlementReportDetailState
    extends State<DatedSettlementReportDetail> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Align(
          alignment: Alignment.centerRight,
          child: widget.date,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          clipBehavior: Clip.hardEdge,
          child: Column(
            children: [
              _TitleSection(
                isExpanded: _isExpanded,
                role: widget.role,
                contractId: widget.contractId,
                resultType: widget.resultType,
                marketType: widget.marketType,
                onExpansionChange: _switchExpansion,
                targetName: widget.targetName,
              ),
              _ContentSection(
                items: widget.items,
                // isExpanded: _isExpanded,
              ),
            ],
          ),
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();

    // _isExpanded = widget.defaultExpanded;
    _isExpanded = true;
  }

  _switchExpansion(bool newExpansion) {
    // setState(() {
    //   _isExpanded = newExpansion;
    // });
  }
}

class _TitleFirstRow extends StatelessWidget {
  final String? contractId;
  final String? targetName;
  final ContractRole role;

  const _TitleFirstRow({
    Key? key,
    required this.targetName,
    this.contractId,
    required this.role,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final members = <Widget>[];

    switch (role) {
      case ContractRole.BUYER:
        members.add(Text('Buyer',
            style: TextStyle(fontSize: 15, color: Color(0xFFF6645A))));
        break;
      case ContractRole.SELLER:
        members.add(Text('Seller',
            style: TextStyle(fontSize: 15, color: Color(0xFF99FF75))));
        break;
    }

    if (contractId != null) {
      members.add(Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Text("Contract \n#$contractId", style: TextStyle(fontSize: 12)),
      ));
    }

    Widget targetWidget;
    if (targetName != null) {
      targetWidget = Text("To $targetName");
    } else {
      targetWidget = Container();
    }

    return Row(
      children: [
        Expanded(
          child: Row(
            children: members,
          ),
        ),
        targetWidget,
      ],
    );
  }
}

class _TitleSecondRow extends StatelessWidget {
  final SettlementResultType resultType;
  final MarketType marketType;

  const _TitleSecondRow({
    required this.resultType,
    required this.marketType,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color displayColor;
    String displayStatus;

    switch (resultType) {
      case SettlementResultType.ENERGY_EXCESS:
        displayColor = Color(0xFF22BA20);
        displayStatus = 'Energy excess';
        break;
      case SettlementResultType.ENERGY_SHORTFALL:
        displayColor = Color(0xFFF6645A);
        displayStatus = 'Energy shortfall';
        break;
      default:
        displayColor = Color(0xFF22BA20);
        displayStatus = 'Energy excess';
        break;
    }

    String marketNameString;
    switch (marketType) {
      case MarketType.BILATERAL:
        marketNameString = 'Short term Bilateral Trade';
        break;
      case MarketType.POOL:
        marketNameString = 'Pool Market Trade';
        break;
      default:
        marketNameString = 'Short term Bilateral Trade';
        break;
    }

    Widget marketName = RichText(
      text: TextSpan(
        text: marketNameString,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
    );

    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: displayColor,
                  borderRadius: BorderRadius.circular(1000),
                ),
                child: SizedBox(
                  width: 12,
                  height: 12,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, top: 1),
                child: Text(displayStatus, style: TextStyle(fontSize: 13)),
              ),
            ],
          ),
        ),
        marketName,
      ],
    );
  }
}

class _TitleSection extends StatelessWidget {
  final ContractRole role;
  final String? contractId;

  final SettlementResultType resultType;
  final bool isExpanded;
  final Function(bool)? onExpansionChange;

  final String? targetName;

  final MarketType marketType;

  const _TitleSection({
    Key? key,
    required this.role,
    required this.isExpanded,
    this.onExpansionChange,
    this.contractId,
    required this.resultType,
    this.targetName,
    required this.marketType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var titleColor = const Color(0xFF473937);
    if (marketType == MarketType.BILATERAL) {
      titleColor = const Color(0xFF37453e);
    }

    return GestureDetector(
      onTap: () => onExpansionChange?.call(!isExpanded),
      child: Container(
        decoration: BoxDecoration(color: titleColor),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          child: Column(
            children: <Widget>[
              _TitleFirstRow(
                key: Key('title_first_row'),
                targetName: targetName,
                role: role,
                contractId: contractId,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: _TitleSecondRow(
                  marketType: marketType,
                  resultType: resultType,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
