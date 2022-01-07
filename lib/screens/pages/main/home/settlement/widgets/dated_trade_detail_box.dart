import 'package:auto_size_text/auto_size_text.dart';
import 'package:egat_flutter/i18n/app_localizations.dart';
import 'package:egat_flutter/screens/pages/main/home/settlement/models/contract_direction.dart';
import 'package:egat_flutter/screens/pages/main/home/settlement/models/contract_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DatedTradeDetailBoxItem {
  final String name;
  final String value;
  final double fontSize;
  final Color fontColor;

  const DatedTradeDetailBoxItem({
    required this.name,
    required this.value,
    this.fontSize = 13,
    this.fontColor = Colors.black,
  });
}

class DatedTradeDetail extends StatefulWidget {
  final TransferDirection direction;
  final Widget date;
  final String? contractId;
  final ContractStatus status;
  final bool defaultExpanded;
  final String? targetName;

  final List<DatedTradeDetailBoxItem> items;

  const DatedTradeDetail({
    Key? key,
    required this.direction,
    required this.date,
    required this.status,
    required this.items,
    this.defaultExpanded = false,
    this.contractId,
    this.targetName,
  }) : super(key: key);

  @override
  _DatedTradeDetailState createState() => _DatedTradeDetailState();
}

class _DatedTradeDetailState extends State<DatedTradeDetail> {
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();

    _isExpanded = widget.defaultExpanded;
  }

  _switchExpansion(bool newExpansion) {
    setState(() {
      _isExpanded = newExpansion;
    });
  }

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
                direction: widget.direction,
                contractId: widget.contractId,
                status: widget.status,
                onExpansionChange: _switchExpansion,
                targetName: widget.targetName,
              ),
              _ContentSection(
                items: widget.items,
                isExpanded: _isExpanded,
              ),
            ],
          ),
        )
      ],
    );
  }
}

class _ContentSection extends StatelessWidget {
  final List<DatedTradeDetailBoxItem> items;
  final bool isExpanded;

  const _ContentSection({
    Key? key,
    required this.items,
    required this.isExpanded,
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

class _TitleSection extends StatelessWidget {
  final TransferDirection direction;
  final String? contractId;

  final ContractStatus status;
  final bool isExpanded;
  final Function(bool)? onExpansionChange;

  final String? targetName;

  const _TitleSection({
    Key? key,
    required this.direction,
    required this.isExpanded,
    this.onExpansionChange,
    this.contractId,
    required this.status,
    this.targetName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onExpansionChange?.call(!isExpanded),
      child: Container(
        decoration: BoxDecoration(color: Color(0xFF3E3E3E)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          child: Column(
            children: <Widget>[
              _TitleFirstRow(
                key: Key('title_first_row'),
                isExpanded: isExpanded,
                direction: direction,
                contractId: contractId,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: _TitleSecondRow(
                  targetName: targetName,
                  status: status,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TitleSecondRow extends StatelessWidget {
  final ContractStatus status;
  final String? targetName;

  const _TitleSecondRow({
    required this.status,
    this.targetName,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color displayColor;
    String displayStatus;

    switch (status) {
      case ContractStatus.OPEN:
        displayColor = Color(0xFFFEC908);
        displayStatus =
            AppLocalizations.of(context).translate('settlement-open');
        break;
      case ContractStatus.MATCHED:
        displayColor = Color(0xFF99FF75);
        displayStatus =
            AppLocalizations.of(context).translate('settlement-matched');
        break;
      default:
        displayColor = Color(0xFFFEC908);
        displayStatus =
            AppLocalizations.of(context).translate('settlement-open');
        break;
    }

    Widget toTargetName;
    if (targetName != null) {
      toTargetName = RichText(
        text: TextSpan(
          text:
              '${AppLocalizations.of(context).translate('settlement-order-to')} ',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
          children: [
            TextSpan(
              text: targetName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    } else {
      toTargetName = Container();
    }

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
        toTargetName,
      ],
    );
  }
}

class _TitleFirstRow extends StatelessWidget {
  final TransferDirection direction;
  final String? contractId;
  final bool isExpanded;

  const _TitleFirstRow({
    Key? key,
    required this.direction,
    required this.isExpanded,
    this.contractId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final members = <Widget>[];

    switch (direction) {
      case TransferDirection.CHOOSE_TO_BUY:
        members.add(Text(
            AppLocalizations.of(context)
                .translate('settlement-order-chooseToBuy'),
            style: TextStyle(fontSize: 15, color: Color(0xFFF6645A))));
        break;
      case TransferDirection.BID_TO_BUY:
        members.add(Text(
            AppLocalizations.of(context).translate('settlement-order-bidToBuy'),
            style: TextStyle(fontSize: 15, color: Color(0xFFF6645A))));
        break;
      case TransferDirection.OFFER_TO_SELL:
        members.add(Text(
            AppLocalizations.of(context)
                .translate('settlement-order-offerToSell'),
            style: TextStyle(fontSize: 15, color: Color(0xFF99FF75))));
        break;
      case TransferDirection.OFFER_TO_SELL_BID:
        members.add(Text(
            AppLocalizations.of(context)
                .translate('settlement-order-offerToSell'),
            style: TextStyle(fontSize: 15, color: Color(0xFF99FF75))));
        break;
    }

    if (contractId != null) {
      members.add(
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Text(
            "Contract \n#$contractId",
            style: TextStyle(fontSize: 12),
          ),
        ),
      );
    }

    final expendedIcon = AnimatedRotation(
      child: Icon(Icons.arrow_drop_up),
      turns: isExpanded ? 0.5 : 0,
      duration: Duration(milliseconds: 100),
      key: Key('arrow'),
    );

    return GestureDetector(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context,constraints) {
                return SizedBox(
                  width: constraints.maxWidth,
                  child: Row(
                    children: members,
                  ),
                );
              }
            ),
          ),
          expendedIcon,
        ],
      ),
    );
  }
}
