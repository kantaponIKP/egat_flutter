import 'package:flutter/widgets.dart';

import 'notification_screen.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return NotificationScreen();
    });
  }
}
