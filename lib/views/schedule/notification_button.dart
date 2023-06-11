import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:f1_flutter/constants/colors.dart';

import '../../services/notification_service.dart';
import '../components/skeleton.dart';

class NotificationButton extends StatefulWidget {
  const NotificationButton({super.key});

  @override
  State<NotificationButton> createState() => _NotificationButtonState();
}

class _NotificationButtonState extends State<NotificationButton> {
  final LocalStorage storage = new LocalStorage('notification_activity');
  var notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    notificationService.initNotification();
  }

  @override
  Widget build(BuildContext context) {
    bool notification_activity = false;
    return Container(
      child: FutureBuilder(
        future: storage.ready,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return _error();
          } else {
            notification_activity = storage.getItem('notification_activity');
            return _notificationButton(notification_activity);
          }
        },
      ),
    );
  }

  _notificationButton(notification_activity) {
    return IconButton(
      icon: Icon(
          notification_activity ? Icons.notifications : Icons.notifications_off,
          color: Colors.black),
      onPressed: () {
        // print(storage.getItem("notification_activity"));
        storage.setItem("notification_activity", !notification_activity);
        setState(() {
          notification_activity = !notification_activity;
        });

        print(notification_activity);
      },
    );
  }

  _error() {
    return Container(
      color: AppColors.white,
      child: Center(child: Image.asset("assets/images/error.png")),
    );
  }
}
