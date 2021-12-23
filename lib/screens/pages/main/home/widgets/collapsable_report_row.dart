import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class CollapsableReportRow extends StatefulWidget {
  final Widget title;
  final Widget value;

  final List<Widget>? collapseItems;
  final bool isDefaultCollapsed;

  final TextStyle? textStyle;
  final TextStyle? collapseTextStyle;

  const CollapsableReportRow({
    Key? key,
    required this.title,
    required this.value,
    this.isDefaultCollapsed = true,
    this.textStyle,
    this.collapseTextStyle,
    this.collapseItems,
  }) : super(key: key);

  @override
  _CollapsableReportRowState createState() => _CollapsableReportRowState();
}

class _CollapsableReportRowState extends State<CollapsableReportRow> {
  bool _isCollapse = true;

  @override
  void initState() {
    super.initState();

    _isCollapse = widget.isDefaultCollapsed;
  }

  @override
  Widget build(BuildContext context) {
    var title = _Title(
      canCollapse: widget.collapseItems != null,
      title: widget.title,
      value: widget.value,
      isCollapsed: _isCollapse,
      textStyle: widget.textStyle,
    );

    if (widget.collapseItems != null) {
      var members = <Widget>[
        title,
        widget.collapseTextStyle != null
            ? DefaultTextStyle(
                style: widget.collapseTextStyle!,
                child: _Collapse(
                  isCollapsed: _isCollapse,
                  children: widget.collapseItems,
                ),
              )
            : _Collapse(
                isCollapsed: _isCollapse,
                children: widget.collapseItems,
              ),
      ];

      return GestureDetector(
        onTap: () => setState(() => _isCollapse = !_isCollapse),
        child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            children: members,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: title,
    );
  }
}

class _Collapse extends StatelessWidget {
  final List<Widget>? children;
  final bool isCollapsed;

  const _Collapse({
    Key? key,
    required this.isCollapsed,
    this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (children == null) {
      return Container();
    }

    return AnimatedSize(
      duration: Duration(milliseconds: 150),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: isCollapsed ? 0 : 2000,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: children!,
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  final bool canCollapse;
  final bool isCollapsed;

  final Widget value;
  final Widget title;

  final TextStyle? textStyle;

  const _Title({
    Key? key,
    required this.title,
    required this.value,
    required this.canCollapse,
    this.isCollapsed = true,
    TextStyle? this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final members = <Widget>[
      Expanded(
        child: title,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: value,
      ),
    ];

    if (canCollapse) {
      members.add(
        AnimatedRotation(
          duration: Duration(milliseconds: 150),
          turns: isCollapsed ? 0 : 0.5,
          child: Icon(Icons.arrow_drop_down),
        ),
      );
    }

    if (textStyle != null) {
      return DefaultTextStyle(
        style: textStyle!,
        child: Row(children: members),
      );
    } else {
      return Row(children: members);
    }
  }
}
