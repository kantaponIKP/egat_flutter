import 'package:egat_flutter/i18n/app_localizations.dart';
import 'package:flutter/material.dart';

class SignupAppbar extends StatelessWidget with PreferredSizeWidget{
  final String firstTitle;
  final String secondTitle;
  final Function() onAction;

  SignupAppbar({Key? key,required this.firstTitle, required this.secondTitle,  required this.onAction, })
      : super(key: key);

 @override
  Widget build(BuildContext context) {
    return PreferredSize(
    preferredSize: const Size.fromHeight(100),
    child: AppBar(
      titleSpacing: -30,
        automaticallyImplyLeading: false,
        leadingWidth: MediaQuery.of(context).size.width,
        leading: Builder(
          builder: (context) => Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () => onAction(),
              ),
              Text('${AppLocalizations.of(context).translate('back')}',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyText2!.color,
                    fontSize: 16,
                  ))
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        bottom: PreferredSize(
            child: Container(
                padding: const EdgeInsets.only(left: 32, right: 32, bottom: 16),
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 30),
                    children: <TextSpan>[
                      TextSpan(text: firstTitle),
                      TextSpan(
                          text: secondTitle,
                          style:
                              TextStyle(color: Theme.of(context).primaryColor)),
                    ],
                  ),
                )),
            preferredSize: Size.fromHeight(50)),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}
