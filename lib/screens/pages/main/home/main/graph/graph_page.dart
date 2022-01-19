import 'package:egat_flutter/screens/pages/main/home/main/graph/graph_screen.dart';
import 'package:egat_flutter/screens/pages/main/states/personal_info_state.dart';
import 'package:flutter/widgets.dart';

class GraphPage extends StatefulWidget {
  String title;
  PersonalInfoModel personalInfo;

  Widget headerIcon;
  String header;

  String valueName;
  String unitName;

  String Function(int index) keyGetter;
  List<double> values;

  double total;
  String totalUnit;

  GraphPage({
    Key? key,
    required this.title,
    required this.personalInfo,
    required this.headerIcon,
    required this.header,
    required this.valueName,
    required this.unitName,
    required this.keyGetter,
    required this.values,
    required this.total,
    required this.totalUnit,
  }) : super(key: key);

  @override
  _GraphPageState createState() => _GraphPageState();
}

class _GraphPageState extends State<GraphPage> {
  @override
  Widget build(BuildContext context) {
    return GraphScreen(
      title: widget.title,
      personalInfo: widget.personalInfo,
      headerIcon: widget.headerIcon,
      header: widget.header,
      valueName: widget.valueName,
      unitName: widget.unitName,
      keyGetter: widget.keyGetter,
      values: widget.values,
      total: widget.total,
      totalUnit: widget.totalUnit,
    );
  }
}
