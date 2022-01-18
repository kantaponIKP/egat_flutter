import 'dart:convert';

import 'package:egat_flutter/Utils/http/get.dart';
import 'package:egat_flutter/constant.dart';
import 'package:http/http.dart';

class NotificationApi {
  Future<GetNotificationResponse> getNotifications({
    required DateTime fromDate,
    required String accessToken,
  }) async {
    Response response;

    var dateRequest = fromDate.toUtc().toIso8601String();

    var url = Uri.parse(
      "$apiBaseUrlNotification/notifications/me",
    ).replace(queryParameters: {
      'from': dateRequest,
    });

    response = await httpGetJson(
      url: url,
      accessToken: accessToken,
    ).timeout(Duration(seconds: 10));

    final jsonMap = json.decode(utf8.decode(response.bodyBytes));

    return GetNotificationResponse.fromJson(jsonMap);
  }
}

class MockNotificationApi extends NotificationApi {
  @override
  Future<GetNotificationResponse> getNotifications({
    required DateTime fromDate,
    required String accessToken,
  }) async {
    return GetNotificationResponse(
      reportDate: DateTime.now(),
      notifications: [
        EgatNotification(
          targetType: 'ALL',
          titleTH: 'titleTH',
          messageTH: 'messageTH',
          titleEN: 'August billing price : 123.45 Baht',
          messageEN: 'Please pay within the specified time. Thank you.',
          createTime: DateTime(2021, 8, 20),
          id: 'id1',
        ),
        EgatNotification(
          targetType: 'ALL',
          titleTH: 'titleTH',
          messageTH: 'messageTH',
          titleEN: 'August billing price : 123.45 Baht',
          messageEN: 'Please pay within the specified time. Thank you.',
          createTime: DateTime(2021, 8, 11),
          id: 'id2',
        ),
        EgatNotification(
          targetType: 'ALL',
          titleTH: 'titleTH',
          messageTH: 'messageTH',
          titleEN: 'August billing price : 123.45 Baht',
          messageEN: 'Please pay within the specified time. Thank you.',
          createTime: DateTime(2021, 8, 06),
          id: 'id3',
        ),
      ],
    );
  }
}

class GetNotificationResponse {
  final DateTime reportDate;
  final List<EgatNotification> notifications;

  const GetNotificationResponse({
    required this.reportDate,
    required this.notifications,
  });

  factory GetNotificationResponse.fromJson(Map<String, dynamic> json) {
    assert(json['reportDate'] is String);
    assert(json['notifications'] is List);

    return GetNotificationResponse(
      reportDate: DateTime.parse(json['reportDate']),
      notifications: (json['notifications'] as List)
          .map<EgatNotification>(
              (e) => EgatNotification.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class EgatNotification {
  final String? targetUserId;
  final String targetType;

  final String titleTH;
  final String messageTH;

  final String titleEN;
  final String messageEN;

  final DateTime createTime;

  final String id;

  const EgatNotification({
    this.targetUserId,
    required this.targetType,
    required this.titleTH,
    required this.messageTH,
    required this.titleEN,
    required this.messageEN,
    required this.createTime,
    required this.id,
  });

  factory EgatNotification.fromJson(Map<String, dynamic> jsonMap) {
    assert(
      jsonMap['targetUserId'] == null || jsonMap['targetUserId'] is String,
    );
    assert(jsonMap['targetType'] is String);
    assert(jsonMap['titleTH'] is String);
    assert(jsonMap['messageTH'] is String);
    assert(jsonMap['titleEN'] is String);
    assert(jsonMap['messageEN'] is String);
    assert(jsonMap['createTime'] is String);
    assert(jsonMap['id'] is String);

    return EgatNotification(
      targetUserId: jsonMap['targetUserId'] as String,
      targetType: jsonMap['targetType'] as String,
      titleTH: jsonMap['titleTH'] as String,
      messageTH: jsonMap['messageTH'] as String,
      titleEN: jsonMap['titleEN'] as String,
      messageEN: jsonMap['messageEN'] as String,
      createTime: DateTime.parse(jsonMap['createTime'] as String),
      id: jsonMap['id'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'targetUserId': targetUserId,
      'targetType': targetType,
      'titleTH': titleTH,
      'messageTH': messageTH,
      'titleEN': titleEN,
      'messageEN': messageEN,
      'createTime': createTime.toIso8601String(),
      'id': id,
    };
  }

  EgatNotification copyWith({
    String? targetUserId,
    String? targetType,
    String? titleTH,
    String? messageTH,
    String? titleEN,
    String? messageEN,
    DateTime? createTime,
    String? id,
  }) {
    return EgatNotification(
      targetUserId: targetUserId ?? this.targetUserId,
      targetType: targetType ?? this.targetType,
      titleTH: titleTH ?? this.titleTH,
      messageTH: messageTH ?? this.messageTH,
      titleEN: titleEN ?? this.titleEN,
      messageEN: messageEN ?? this.messageEN,
      createTime: createTime ?? this.createTime,
      id: id ?? this.id,
    );
  }

  operator ==(Object other) =>
      identical(this, other) ||
      other is EgatNotification &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

final NotificationApi notificationApi = new NotificationApi();
