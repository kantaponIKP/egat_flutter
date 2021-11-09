import 'dart:developer';

import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/i18n/app_localizations.dart';
import 'package:flutter/material.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({Key? key}) : super(key: key);

  @override
  _PrivacyPolicyState createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  List<bool> _isExpanded = List.generate(10, (_) => false);

  static const privacyContents = [
    {
      'title': 'What information do we collect about you ?',
      'content':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore'
    },
    {
      'text': 'How do we use your information ?',
      'content':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore'
    },
    {
      'text': 'To whom do we disclose your information ?',
      'content':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore'
    },
    {
      'text': 'What do we do to keep your information secured ?',
      'content':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore'
    },
    {
      'text': 'Cookies, because and geo tracking',
      'content':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore'
    },
  ];

  @override
  SimpleDialog build(BuildContext context) {
    return SimpleDialog(
        backgroundColor: contentBgColor,
        contentPadding: EdgeInsets.all(30.0),
        title: _buildTitle(context),
        children: [_buildAction(context)]);
  }

  // Widget _buildExpansionPanelList(context) {
  //   return ExpansionPanelList(
  //     expansionCallback: (index, isExpanded) => setState(() {
  //       _isExpanded[index] = !isExpanded;
  //     }),
  //     children: [
  //       for (int i = 0; i < 10; i++)
  //         ExpansionPanel(
  //           body: ListTile(
  //               subtitle: Text(
  //                   "... amet, consectetur adipiscing elit. Nullam ultricies porta rutrum. Vivamus id ultrices velit. Sed tellus lorem, egestas ac magna non, fringilla sagittis erat. Interdum et malesuada fames ac ante ipsum primis in faucibus. Fusce tempor mi et eleifend fermentum. Sed quis molestie nunc.")),
  //           headerBuilder: (_, isExpanded) {
  //             return Center(
  //               child: Text("Lorem ipsum dolor sit ..."),
  //             );
  //           },
  //           isExpanded: _isExpanded[i],
  //         )
  //     ],
  //   );
  // }
  Widget _buildTitle(context) {
    return Row(children: [
      Expanded(
        child: RichText(
            text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
              TextSpan(
                  text: AppLocalizations.of(context).translate('privacy'),
                  style: TextStyle(fontSize: 20)),
              TextSpan(
                  text: AppLocalizations.of(context).translate('policy'),
                  style: TextStyle(fontSize: 20, color: primaryColor)),
            ])),
      ),
      IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.close,
            color: whiteColor,
          ))
    ]);
  }

  Widget _buildAction(context) {
    return Container(
      // height: MediaQuery.of(context).size.height - 10,
      // width: MediaQuery.of(context).size.width -,
      child: Column(
        children: [
          _buildParagraph(context),
          _buildContent(context),
          // _buildCard(),
          // _buildExpansionPanelList(context)
        ],
      ),
    );
  }
  // Widget _buildDialog(context){
  //   return
  // }

  _buildParagraph(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
      child: Text('${AppLocalizations.of(context).translate('aggrement-1')}'),
    );
  }

  _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 1; i <= 5; i++)
          _buildCard(i),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 16.0, 0, 0),
          child: Text(
            '${AppLocalizations.of(context).translate('effective-date')}',
            style: TextStyle(fontSize: 10),
          ),
        )
      ],
    );
  }

  _buildCard(var privacyNumber) {
    return Card(
      color: primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              _buildCardContent(privacyNumber),
            ],
          )),
    );
  }

  // _buildCardContent(Map<String, String> privacyContent) {
    _buildCardContent(var number){
    return ExpansionTile(
      trailing: Icon(
        Icons.add,
        color: Colors.black,
      ),
      title: Text(
        '${AppLocalizations.of(context).translate('privacy-$number')}',
        style: TextStyle(fontSize: 15, color: Colors.black),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('What information do we collect about asdfasfdas',
              style: TextStyle(fontSize: 15, color: Colors.black)),
        ),
      ],
    );
  }
}
