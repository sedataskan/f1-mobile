import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../constants/colors.dart';
import '../../services/notification_service.dart';
import 'models/race.dart';
import 'models/race_data_source.dart';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  var notificationService = NotificationService();

  Future<List<dynamic>> getData() async {
    var url = Uri.https('ergast.com', '/api/f1/current.json', {'q': '{http}'});

    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      return jsonResponse["MRData"]["RaceTable"]["Races"].toList();
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    notificationService.initNotification();
    getData();
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

  List<Race> _getDataSource(List<dynamic> data) {
    final List<Race> races = <Race>[];
    final DateTime today = DateTime.now();

    for (var i = 0; i < data.length; i++) {
      final year = data[i]["date"].split("-")[0];
      final month = data[i]["date"].split("-")[1];
      final day = data[i]["date"].split("-")[2];
      final time = data[i]["time"].split(":")[0];

      final DateTime date = DateTime(
          int.parse(year), int.parse(month), int.parse(day), int.parse(time));

      final color = date == today
          ? Colors.green
          : date.isBefore(today)
              ? Colors.red
              : Colors.blue;

      races.add(Race(data[i]["raceName"], date, date, color, false));
    }

    return races;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule', style: TextStyle(color: Colors.black)),
        backgroundColor: AppColors.primaryColorLight,
      ),
      body: FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              color: AppColors.white,
              child: const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryColor,
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return _error();
          } else {
            var data = snapshot.data!;
            return data.isEmpty ? _error() : _races(data);
          }
        },
      ),
    );
  }

  Container _races(List<dynamic> data) {
    return Container(
      color: AppColors.white,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: SfCalendar(
            view: CalendarView.schedule,
            scheduleViewSettings: ScheduleViewSettings(
              appointmentItemHeight: 60,
              monthHeaderSettings: MonthHeaderSettings(
                height: 70,
                textAlign: TextAlign.start,
                monthTextStyle: TextStyle(
                  fontSize: 20,
                  color: AppColors.black,
                ),
                backgroundColor: AppColors.primaryColorLight,
              ),
            ),
            todayHighlightColor: AppColors.primaryColor,
            dataSource: RaceDataSource(_getDataSource(data)),
            onTap: (CalendarTapDetails details) {
              print(details.appointments?[0].getEventName());
            },
          ),
        ),
      ),
    );
  }

  _error() {
    return Container(
      color: AppColors.white,
      child: Center(child: Image.asset("assets/images/error.png")),
    );
  }
}
