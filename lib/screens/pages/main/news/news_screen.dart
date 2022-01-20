import 'dart:math';

import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/screens/pages/main/news/news_description_screen.dart';
import 'package:egat_flutter/screens/pages/main/news/state/news_state.dart';
import 'package:egat_flutter/screens/pages/main/widgets/navigation_menu_widget.dart';
import 'package:egat_flutter/screens/widgets/loading_dialog.dart';
import 'package:egat_flutter/screens/widgets/show_exception.dart';
import 'package:egat_flutter/screens/widgets/show_snackbar.dart';
import 'package:egat_flutter/screens/widgets/single_child_scoped_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';
import 'package:markdown/markdown.dart' as markdown;
import 'package:provider/provider.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  initState() {
    super.initState();
    fetchNews();
  }

  Future<void> fetchNews() async {
    await showLoading();
    try {
      final newsState = Provider.of<NewsState>(context, listen: false);
      await newsState.init();
    } catch (e) {
      showIntlException(context, e);
    } finally {
      await hideLoading();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationMenuWidget(),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [
                Color(0xFF303030),
                Colors.black,
              ],
            ),
          ),
          child: _buildAction(context),
        ),
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
          _NewsListSection(),
          _NewsPaginationSection(),
        ],
      )),
    );
  }
}

class _NewsListSection extends StatelessWidget {
  const _NewsListSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final newsState = Provider.of<NewsState>(context);

    return Column(
      children: [
        for (var news in newsState.newsOnCurrentPage)
          _NewsCardSection(
            date: news.createdAt!,
            title: news.title!,
            content: news.description!,
          ),
      ],
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

  final DateTime date;
  final String title;
  final String content;
  final void Function()? onTap;

  void _onNewPressed(
      {required BuildContext context, required String fullContent}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return NewsDescriptionScreen(title: title, content: fullContent);
        },
      ),
    );
  }

  String removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

    return htmlText.replaceAll(exp, '');
  }

  @override
  Widget build(BuildContext context) {
    // Content can't have more than 60 characters
    // If title is more than 60 characters, it will be cut off
    final fullContent = this.content;
    final htmlText = markdown.markdownToHtml(this.content);
    final plainText = removeAllHtmlTags(htmlText);

    final content = this.content.length > 49
        ? this.content.substring(0, 46) + '...'
        : this.content;

    var dateFormatter = DateFormat('dd MMM yyyy');
    var date = dateFormatter.format(this.date);

    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: GestureDetector(
        onTap: () {
          _onNewPressed(context: context, fullContent: fullContent);
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
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
                            color: greyColor,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    )),
                  ),
                  Container(
                    constraints: BoxConstraints(
                      minHeight: 45,
                      maxHeight: 45,
                    ),
                    child: Align(
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
                  ),
                  Container(
                    constraints: BoxConstraints(
                      minHeight: 35,
                      maxHeight: 35,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child:
                          // Markdown(
                          //   physics: NeverScrollableScrollPhysics(),
                          //   // controller: null,
                          //   // softLineBreak: true,
                          //   data: content,
                          //   shrinkWrap: true,
                          // )
                          RichText(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: plainText,
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              )),
                    ),
                  ),
                ]),
              )),
            ),
          ),
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
    final startFrom = max(0, newsState.currentPage - 1);
    final endAt = min(newsState.totalPage - 1, newsState.currentPage + 1);

    var items = <int>[];
    for (var i = startFrom; i <= endAt && items.length < 3; i++) {
      items.add(i + 1);
    }
    print(items);

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
                  style: TextStyle(color: primaryColor),
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
      showSnackbar(context, e.toString()); //TODO
    }
  }

  tryFetchPage(BuildContext context, NewsState newsState, int page) async {
    try {
      print("Page: " + page.toString());
      await newsState.fetchNewsAtPage(page);
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }
}
