import 'package:f1_flutter/views/schedule/schedule_dialog.dart';
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

      final DateTime date = DateTime.utc(int.parse(year), int.parse(month),
              int.parse(day), int.parse(time))
          .toLocal();

      final color = date.day == today.day
          ? Colors.green
          : date.isBefore(today)
              ? Colors.red
              : Colors.blue;

      races.add(Race(data[i]["raceName"], date, date, color, false,
          data[i]["Circuit"]["Location"]["locality"], data[i]["url"]));
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
            appointmentBuilder: (BuildContext context,
                CalendarAppointmentDetails calendarAppointmentDetails) {
              return Container(
                decoration: BoxDecoration(
                  color: calendarAppointmentDetails.appointments.first
                      .getBackground(),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    calendarAppointmentDetails.appointments.first
                            .getEventName() +
                        "\n" +
                        calendarAppointmentDetails.appointments.first
                            .getFrom()
                            .toString()
                            .split(" ")[1]
                            .split(".")[0]
                            .substring(0, 5),
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              );
            },
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
              String eventName = details.appointments?[0].getEventName() ?? "";
              String eventLoc = details.appointments?[0].getEventLoc() ?? "";

              String eventDate =
                  details.appointments?[0].getFrom().toString().split(".")[0] ??
                      "";
              String eventTime = eventDate.substring(0, eventDate.length - 3);
              String year = eventDate.split("-")[0];
              // String month = eventDate.split("-")[1].startsWith("0")
              //     ? eventDate.split("-")[1].substring(1)
              //     : eventDate.split("-")[1];
              // String day = eventDate.split("-")[2].startsWith("0")
              //     ? eventDate.split("-")[2].substring(1, 2)
              //     : eventDate.split("-")[2].substring(0, 2);

              // String hour = eventTime.split(" ")[1].split(":")[0];
              // String minute = eventTime.split(" ")[1].split(":")[1];

              String eventUrl = details.appointments?[0]
                      .getEventUrl()
                      .replaceAll(year + "_", "") ??
                  "";
              if (details.appointments?[0].getEventName() != null) {
                showModalBottomSheet<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return InkWell(
                      onTap: () {
                        ScheduleDialog(
                          eventName: eventName,
                          eventTime: eventTime,
                          eventLoc: eventLoc,
                          wikipedia: eventUrl,
                        );
                      },
                    );
                  },
                );
              }
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
