import 'dart:math';

import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/screens/forgot_password/widgets/forgot_password_cancellation_dialog.dart';
import 'package:egat_flutter/screens/page/news/state/news_state.dart';
import 'package:egat_flutter/screens/page/widgets/page_appbar.dart';
import 'package:egat_flutter/screens/page/widgets/side_menu.dart';
import 'package:egat_flutter/screens/widgets/single_child_scoped_scroll_view.dart';
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

  initState() {
    super.initState();
    final newsState = Provider.of<NewsState>(context, listen: false);
    newsState.init();
  }

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
      child: SingleChildScopedScrollView(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          //TODO: loop
          Column(
            children: [
              _NewsCardSection(date: date, title: news, content: content),
              _NewsCardSection(date: date, title: news, content: content),
              _NewsCardSection(date: date, title: news, content: content),
              _NewsCardSection(date: date, title: news, content: content),
            ],
          ),
          _NewsPaginationSection(),
        ],
      )),
    );
  }
}

class _NewsCardSection extends StatelessWidget {
  const _NewsCardSection({
    Key? key,
    required this.date,
    required this.title,
    required this.content,
    this.onTap,
  }) : super(key: key);

  final String date;
  final String title;
  final String content;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    // Title can't have more than 20 characters
    // If title is more than 20 characters, it will be cut off
    final title = this.title.length > 20
        ? this.title.substring(0, 17) + '...'
        : this.title;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: InkWell(
        onTap: this.onTap,
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
                        text: title,
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
}

class _NewsPaginationSection extends StatelessWidget {
  const _NewsPaginationSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final newsState = Provider.of<NewsState>(context);

    final startFrom = max(0, newsState.currentPage - 2);
    final endAt = min(newsState.totalPage, newsState.currentPage + 1);

    var items = <int>[];
    for (var i = startFrom; i <= endAt && items.length < 3; i++) {
      items.add(i + 1);
    }

    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      TextButton(
        child: Text('<', style: TextStyle(color: textColor)),
        onPressed: () =>
            tryFunctionHandleErrors(context, newsState.fetchPreviousPage),
      ),
      for (var item in items)
        item == newsState.currentPage + 1
            ? TextButton(
                child: Text(
                  item.toString(),
                  style: TextStyle(color: textColor),
                ),
                onPressed: () => tryFetchPage(context, newsState, item - 1),
              )
            : TextButton(
                child: Text(
                  item.toString(),
                  style: TextStyle(color: textColor),
                ),
                onPressed: () => tryFetchPage(context, newsState, item - 1),
              ),
      TextButton(
        child: Text('>', style: TextStyle(color: textColor)),
        onPressed: () =>
            tryFunctionHandleErrors(context, newsState.fetchNextPage),
      ),
    ]);
  }

  tryFunctionHandleErrors(
      BuildContext context, Future<void> Function() function) async {
    try {
      await function();
    } catch (e) {
      showException(context, e.toString());
    }
  }

  tryFetchPage(BuildContext context, NewsState newsState, int page) async {
    try {
      await newsState.fetchNewsAtPage(page);
    } catch (e) {
      showException(context, e.toString());
    }
  }
}
