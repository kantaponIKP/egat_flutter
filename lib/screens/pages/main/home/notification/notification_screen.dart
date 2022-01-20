import 'package:egat_flutter/screens/pages/main/home/apis/notification_api.dart';
import 'package:egat_flutter/screens/pages/main/home/states/notification.state.dart';
import 'package:egat_flutter/screens/pages/main/states/main_screen_title_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();

    final notificationState =
        Provider.of<NotificationState>(context, listen: false);
    notificationState.fetchNotifications();

    final MainScreenTitleState titleState =
        context.read<MainScreenTitleState>();

    titleState.setTitleLogo();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [
            Color(0xFF303030),
            Colors.black,
          ],
        ),
      ),
      child: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: constraints.maxHeight,
          width: constraints.maxWidth,
          child: SingleChildScrollView(
            child: _buildContent(context),
          ),
        );
      },
    );
  }

  _buildContent(BuildContext context) {
    final notificationState = Provider.of<NotificationState>(context);
    final notifications = [...notificationState.notifications];
    notifications.sort((a, b) => b.createTime.compareTo(a.createTime));

    return Padding(
      padding: EdgeInsets.all(16),
      child: Scrollbar(
        child: Column(
          children: [
            for (final notification in notifications)
              Column(
                children: [
                  _Notification(
                    notification: notification,
                    onDelete: () {
                      notificationState.removeNotifications([notification]);
                    },
                  ),
                  SizedBox(height: 12),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _Notification extends StatelessWidget {
  final EgatNotification notification;
  final Function()? onDelete;

  const _Notification({
    Key? key,
    required this.notification,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy  HH:mm');
    final dateString = dateFormat.format(notification.createTime.toLocal());

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: constraints.maxWidth,
          decoration: BoxDecoration(
            color: Color(0xFF262729),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      dateString,
                      style: TextStyle(
                        color: const Color(0xFFFEC908),
                        fontSize: 12,
                      ),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: onDelete,
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Text(
                  notification.titleEN,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  notification.messageEN,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
