import 'package:cached_network_image/cached_network_image.dart';
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
  final String eventTime;
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

  late String imageLink =
      "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png";

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
        widget.eventName, widget.eventTime, widget.eventLoc, widget.wikipedia);
  }

  _dialog(eventName, eventTime, eventLoc, eventUrl) {
    return SizedBox(
      height: 300,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(eventName, style: TextStyle(fontSize: 20)),
            Text(eventTime, style: TextStyle(fontSize: 15)),
            Text(eventLoc, style: TextStyle(fontSize: 15)),
            CachedNetworkImage(
              imageUrl: eventUrl,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ],
        ),
      ),
    );
  }
}
