import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../constants/colors.dart';
import '../../services/notification_service.dart';
import 'models/race.dart';
import 'models/race_data_source.dart';

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

  // @override
  // Widget build(BuildContext context) {
  //   return ElevatedButton(
  //       onPressed: () {
  //         notificationService.showNotification(
  //           title: "Test",
  //           body: "Test1",
  //         );
  //         DateTime scheduledDate = DateTime.now()
  //             .add(Duration(minutes: 1)); // Örnek olarak 1 saat sonra
  //         notificationService.scheduleNotification(
  //           id: 1,
  //           title: 'Bildirim Başlığı',
  //           body: 'Bildirim İçeriği',
  //           scheduledDate: scheduledDate,
  //         );
  //       },
  //       child: Text("Send Noti"));
  // }

  List<Race> _getDataSource() {
    final List<Race> races = <Race>[];
    final DateTime today = DateTime.now();
    final DateTime day1 = DateTime(today.year, today.month, today.day, 9);
    final DateTime day2 = DateTime(today.year, today.month, today.day + 10, 9);
    races.add(Race('Race 1', day1, day1, Color(0xFF0F8644), false));
    races.add(
        Race('Race 2', day2, day2, Color.fromARGB(255, 109, 161, 133), false));
    return races;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Schedule', style: TextStyle(color: Colors.black)),
          backgroundColor: AppColors.primaryColorLight,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SfCalendar(
            view: CalendarView.schedule,
            dataSource: RaceDataSource(_getDataSource()),
            onTap: (CalendarTapDetails details) {
              print(details.appointments?[0].getEventName());
            },
          ),
        ));
  }
}
