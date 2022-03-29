import 'package:egat_flutter/i18n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../models/contract_direction.dart';
import '../models/contract_status.dart';
import '../models/energy_transfer_info.dart';

class DatedEnergyDetail extends StatefulWidget {
  final TransferDirection direction;
  final Widget date;
  final String? contractId;
  final EnergyTransferStatus status;
  final bool defaultExpanded;
  final String? targetName;

  final List<DatedEnergyDetailBoxItem> items;

  const DatedEnergyDetail({
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
  _DatedEnergyDetailState createState() => _DatedEnergyDetailState();
}

class DatedEnergyDetailBoxItem {
  final String name;
  final String value;
  final double fontSize;
  final Color fontColor;

  const DatedEnergyDetailBoxItem({
    required this.name,
    required this.value,
    this.fontSize = 13,
    this.fontColor = Colors.black,
  });
}

class _ContentSection extends StatelessWidget {
  final List<DatedEnergyDetailBoxItem> items;
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

class _DatedEnergyDetailState extends State<DatedEnergyDetail> {
  bool _isExpanded = false;

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
                .translate('settlement-energyTransfer-chooseToBuy'),
            style: TextStyle(fontSize: 15, color: Color(0xFFF6645A))));
        break;
      case TransferDirection.BID_TO_BUY:
        members.add(Text(
            AppLocalizations.of(context)
                .translate('settlement-energyTransfer-bidToBuy'),
            style: TextStyle(fontSize: 15, color: Color(0xFFF6645A))));
        break;
      case TransferDirection.OFFER_TO_SELL:
        members.add(Text(
            AppLocalizations.of(context)
                .translate('settlement-energyTransfer-offerToSell'),
            style: TextStyle(fontSize: 15, color: Color(0xFF99FF75))));
        break;
      case TransferDirection.OFFER_TO_SELL_BID:
        members.add(Text(
            AppLocalizations.of(context)
                .translate('settlement-energyTransfer-offerToSell'),
            style: TextStyle(fontSize: 15, color: Color(0xFF99FF75))));
        break;
      case TransferDirection.GRID_SELL:
        members.add(
          Text(
            'Sell to Grid',
            style: TextStyle(
              fontSize: 15,
              color: Color(0xFF99FF75),
            ),
          ),
        );
        break;
      case TransferDirection.GRID_BUY:
        members.add(
          Text(
            'Buy from Grid',
            style: TextStyle(
              fontSize: 15,
              color: Color(0xFFF6645A),
            ),
          ),
        );
        break;
    }

    if (contractId != null) {
      members.add(Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Text("Contract \n#$contractId", style: TextStyle(fontSize: 12)),
      ));
    }

    final expendedIcon = AnimatedRotation(
      child: Icon(Icons.arrow_drop_up),
      turns: isExpanded ? 0.5 : 0,
      duration: Duration(milliseconds: 100),
      key: Key('arrow'),
    );

    return GestureDetector(
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: members,
            ),
          ),
          expendedIcon,
        ],
      ),
    );
  }
}

class _TitleSecondRow extends StatelessWidget {
  final EnergyTransferStatus status;
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
      case EnergyTransferStatus.COMPLETED:
        displayColor = Color(0xFF99FF75);
        displayStatus =
            AppLocalizations.of(context).translate('settlement-matched');
        break;
      case EnergyTransferStatus.SCHEDULED:
        displayColor = Color(0xFFF8E294);
        displayStatus =
            AppLocalizations.of(context).translate('settlement-matched');
        break;
      default:
        displayColor = Color(0xFF99FF75);
        displayStatus =
            AppLocalizations.of(context).translate('settlement-completed');
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

class _TitleSection extends StatelessWidget {
  final TransferDirection direction;
  final String? contractId;

  final EnergyTransferStatus status;
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
    var titleColor = const Color(0xFF473937);
    if (direction == TransferDirection.OFFER_TO_SELL ||
        direction == TransferDirection.CHOOSE_TO_BUY) {
      titleColor = const Color(0xFF37453e);
    }
    if (direction == TransferDirection.GRID_BUY ||
        direction == TransferDirection.GRID_SELL) {
      titleColor = const Color(0xFF3E3E3E);
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
