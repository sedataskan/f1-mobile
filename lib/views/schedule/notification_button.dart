import 'package:f1_flutter/helper/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:f1_flutter/constants/colors.dart';

import '../../services/notification_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

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
  Widget build(BuildContext context) {
    bool notification_activity = false;
    return Container(
      child: FutureBuilder(
        future: storage.ready,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return _error();
          } else {
            notification_activity =
                storage.getItem('notification_activity') ?? false;
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
        // confirm dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Notifications"),
              content: notification_activity
                  ? Text("Do you want to turn off notifications?")
                  : Text("Do you want to turn on notifications?"),
              actions: [
                TextButton(
                  child: Text("Hayır"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text("Evet"),
                  onPressed: () async {
                    storage.setItem(
                        "notification_activity", !notification_activity);
                    setState(() {
                      notification_activity = !notification_activity;
                    });

                    if (notification_activity) {
                      final data = await getData();

                      final DateTime today = DateTime.now();

                      for (var i = 0; i < data.length; i++) {
                        final year = data[i]["date"].split("-")[0];
                        final month = data[i]["date"].split("-")[1];
                        final day = data[i]["date"].split("-")[2];
                        final time = data[i]["time"].split(":")[0];

                        final DateTime date = DateTime.utc(
                                int.parse(year),
                                int.parse(month),
                                int.parse(day),
                                int.parse(time))
                            .toLocal();

                        if (date.isAfter(today)) {
                          // DateTime testDate =
                          //     DateTime.now().add(Duration(seconds: 5));
                          DateTime scheduledDate =
                              date.subtract(Duration(hours: 1));

                          notificationService.scheduleNotification(
                            id: int.parse(data[i]["round"]),
                            title: "Race Time!",
                            body: data[i]["raceName"].split("Grand")[0] +
                                "GP" +
                                " - " +
                                DateFormatter.getFormattedTime(date),
                            scheduledDate: scheduledDate,
                          );
                        }
                      }
                    } else {
                      notificationService.cancelAllNotifications();
                    }
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
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
