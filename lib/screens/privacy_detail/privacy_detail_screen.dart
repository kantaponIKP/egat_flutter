import 'dart:developer';

import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/i18n/app_localizations.dart';
import 'package:flutter/material.dart';

class PrivacyDetails extends StatefulWidget {
  const PrivacyDetails({Key? key}) : super(key: key);

  @override
  _PrivacyDetailsState createState() => _PrivacyDetailsState();
}

class _PrivacyDetailsState extends State<PrivacyDetails> {
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
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      RichText(
          text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
            TextSpan(
                // text: AppLocalizations.of(context).translate('privacy') + ' ',
                text: "Privacy",
                style: TextStyle(fontSize: 20)),
            TextSpan(
                // text: AppLocalizations.of(context).translate('policy') + ' ',
                text: "Policy",
                style: TextStyle(fontSize: 20, color: primaryColor)),
          ])),
      IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.close,
            color: white,
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
      child: Text(
          'We want you to know exactly how EGAT P2P app work and why we need your details, Reviewing our policy will help you continue using the app with peace of mind.'),
    );
  }

  _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < privacyContents.length; i++)
          _buildCard(privacyContents[i]),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 16.0, 0, 0),
          child: Text(
            'Effective from August 2021',
            style: TextStyle(fontSize: 10),
          ),
        )
      ],
    );
  }

  _buildCard(Map<String, String> privacyContent) {
    return Card(
      color: primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              _buildCardContent(privacyContent),
            ],
          )),
    );
  }

  _buildCardContent(Map<String, String> privacyContent) {
    return ExpansionTile(
      trailing: Icon(
        Icons.add,
        color: Colors.black,
      ),
      title: Text(
        'What information do we collect about you ?',
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
