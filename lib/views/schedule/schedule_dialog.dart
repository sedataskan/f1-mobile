import 'package:cached_network_image/cached_network_image.dart';
import 'package:f1_flutter/helper/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class ScheduleDialog extends StatefulWidget {
  ScheduleDialog(
      {super.key,
      required this.eventName,
      required this.eventTime,
      required this.eventLoc,
      required this.wikipedia});

  final String eventName;
  final DateTime eventTime;
  final String eventLoc;
  final String wikipedia;

  @override
  State<StatefulWidget> createState() => _ScheduleDialogState();
}

class _ScheduleDialogState extends State<ScheduleDialog> {
  initState() {
    super.initState();
    getData(
        widget.wikipedia.split("/")[widget.wikipedia.split("/").length - 1]);
  }

  late String imageLink = " ";

  late String about = "Loading...";

  bool isTriedGetData = false;

  Future<void> getData(String wikipediaTitle) async {
    try {
      var url = Uri.https(
          'en.wikipedia.org',
          '/api/rest_v1/page/mobile-sections-lead/' +
              Uri.decodeComponent(wikipediaTitle));

      // Await the http get response, then decode the json-formatted response.
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var jsonResponse =
            convert.jsonDecode(response.body) as Map<String, dynamic>;

        setState(() {
          imageLink = jsonResponse["image"]["urls"]["320"];
        });
      } else {
        print('Request failed with status: ${response.statusCode}.');
        if (!isTriedGetData) {
          getData(widget.wikipedia);
          isTriedGetData = true;
        } else {
          setState(() {
            about = "No data found";
          });
        }
      }
    } catch (e) {
      print(e);
      setState(() {
        about = "No data found";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _dialog(
        widget.eventName, widget.eventTime, widget.eventLoc, imageLink);
  }

  _dialog(eventName, DateTime eventTime, eventLoc, eventUrl) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                eventName,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                DateFormatter.getFormattedDate(eventTime),
                style: TextStyle(fontSize: 15),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(eventLoc, style: TextStyle(fontSize: 15)),
              Text(DateFormatter.getFormattedTime(eventTime),
                  style: TextStyle(fontSize: 15)),
            ],
          ),
          SizedBox(height: 10),
          CachedNetworkImage(
            imageUrl: eventUrl,
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                Center(
              child: CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
