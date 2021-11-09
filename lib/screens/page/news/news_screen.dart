import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/i18n/app_localizations.dart';
import 'package:egat_flutter/screens/page/widgets/page_appbar.dart';
import 'package:egat_flutter/screens/page/widgets/page_bottom_navigation_bar.dart';
import 'package:egat_flutter/screens/page/widgets/side_menu.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  String news =
      'รวมพลังกลุ่ม กฟผ. มอบเงิน 3 ล้านบาท จัดหายาฟ้าทะลายโจรช่วยผู้ป่วยโควิด-19';
  String date = '13 Aug 2021';
  String content = 'วันนี้ (13 สิงหาคม 2564) นายกิจจา ศรีพัฒากุระ กรรมการ';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageAppbar(firstTitle: "", secondTitle: "News"),
      drawer: NavigationMenuWidget(),
      body: SafeArea(
        child: _buildAction(context),
      ),
    );
  }

  Padding _buildAction(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 6),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  //TODO: loop
                  Column(
                    children: [
                      _buildInformationSection(),
                      _buildInformationSection(),
                      _buildInformationSection(),
                      _buildInformationSection(),
                    ],
                  ),
                  _buildPaginationSection(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  //TODO: pagination
  Widget _buildPaginationSection(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(child: Text('<', style: TextStyle(color: textColor)), onPressed: () => null,),
        TextButton(child: Text('1', style: TextStyle(color: textColor)), onPressed: () => null,),
        TextButton(child: Text('2', style: TextStyle(color: textColor)), onPressed: () => null,),
        TextButton(child: Text('3', style: TextStyle(color: textColor)), onPressed: () => null,),
        TextButton(child: Text('>', style: TextStyle(color: textColor)), onPressed: () => null,),
      ]
    );
  }

  Widget _buildInformationSection() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: InkWell(
        onTap: () {
          print('Card tapped.');
        },
        child: SizedBox(
          child: Center(
              child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(children: [
              Align(
                alignment: Alignment.centerRight,
                child: RichText(
                    text: TextSpan(
                  children: [
                    TextSpan(
                      text: date,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                )),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: RichText(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: news,
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: RichText(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: content,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    )),
              ),
            ]),
          )),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
              text: news,
              style: TextStyle(
                fontSize: 16,
              )),
        ],
      ),
    );
  }
}
