import 'package:flutter/material.dart';

import '../../services/notification_service.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  var notificationService = NotificationService();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notificationService.initNotification();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          notificationService.showNotification(
            title: "Test",
            body: "Test1",
          );
          DateTime scheduledDate = DateTime.now()
              .add(Duration(minutes: 1)); // Örnek olarak 1 saat sonra
          notificationService.scheduleNotification(
            id: 1,
            title: 'Bildirim Başlığı',
            body: 'Bildirim İçeriği',
            scheduledDate: scheduledDate,
          );
        },
        child: Text("Send Noti"));
  }
}
