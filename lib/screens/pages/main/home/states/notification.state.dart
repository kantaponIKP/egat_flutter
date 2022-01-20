import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:egat_flutter/screens/pages/main/home/apis/notification_api.dart';
import 'package:egat_flutter/screens/session.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationState extends ChangeNotifier {
  Set<EgatNotification> _notifications = Set();
  UnmodifiableListView<EgatNotification> get notifications =>
      UnmodifiableListView<EgatNotification>(_notifications);

  int get count => _notifications.length;

  SharedPreferences? _prefs;

  Timer? _timer;
  LoginSession? _loginSession;

  NotificationState() {
    _timer = Timer.periodic(Duration(seconds: 30), (timer) {
      fetchNotifications();
    });
  }

  setLoginSession(LoginSession loginSession) {
    if (_loginSession == loginSession) {
      return;
    }

    _initAsync();

    _loginSession = loginSession;
    fetchNotifications();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  _initAsync() async {
    _prefs = await SharedPreferences.getInstance();

    if (_prefs == null) {
      return;
    }

    String? savedNotificationInfo = _prefs?.getString('notifications');
    // TODO: remove these 2 lines
    savedNotificationInfo = null;
    _currentFetchDate = DateTime(1970);

    if (savedNotificationInfo != null) {
      _SavedNotificationInfo info;
      try {
        info = _SavedNotificationInfo.fromJson(
          json.decode(savedNotificationInfo) as Map<String, dynamic>,
        );

        _notifications.addAll(info.notifications);
        _currentFetchDate = info.currentFetchDate;
      } catch (e) {
        print(e);
        _currentFetchDate = DateTime(1970);
      }
    }

    notifyListeners();
  }

  DateTime _currentFetchDate = DateTime(1970);
  DateTime get currentFetchDate => _currentFetchDate;

  void _addNotifications(List<EgatNotification> notification) {
    _notifications.addAll(notification);
    _saveNotificationInfo();
    notifyListeners();
  }

  void removeNotifications(List<EgatNotification> notification) {
    _notifications.removeWhere((element) => notification.contains(element));
    _saveNotificationInfo();
    notifyListeners();
  }

  void fetchNotifications({
    String? accessToken,
  }) async {
    GetNotificationResponse notificationResponse =
        await notificationApi.getNotifications(
            fromDate: _currentFetchDate,
            accessToken: accessToken ?? _loginSession?.info?.accessToken ?? '');

    _currentFetchDate = notificationResponse.reportDate;
    _addNotifications(notificationResponse.notifications);
  }

  void _saveNotificationInfo() {
    if (_prefs == null) {
      return;
    }

    _SavedNotificationInfo info = _SavedNotificationInfo(
      notifications: [..._notifications],
      currentFetchDate: _currentFetchDate,
    );

    _prefs?.setString('notifications', json.encode(info));
  }
}

class _SavedNotificationInfo {
  final List<EgatNotification> notifications;
  final DateTime currentFetchDate;

  const _SavedNotificationInfo({
    required this.notifications,
    required this.currentFetchDate,
  });

  factory _SavedNotificationInfo.fromJson(Map<String, dynamic> json) {
    return _SavedNotificationInfo(
      notifications: (json['notifications'] as List)
          .map((dynamic notification) =>
              EgatNotification.fromJson(notification as Map<String, dynamic>))
          .toList(),
      currentFetchDate: DateTime.parse(json['currentFetchDate'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notifications': notifications,
      'currentFetchDate': currentFetchDate.toIso8601String(),
    };
  }
}
