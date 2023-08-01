import 'package:f1_flutter/constants/colors.dart';
import 'package:f1_flutter/views/components/skeleton.dart';
import 'package:f1_flutter/views/weekly/weekly_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../components/indicator.dart';

class WeeklyScreen extends StatefulWidget {
  const WeeklyScreen({super.key});
  @override
  State<WeeklyScreen> createState() => _WeeklyScreenState();
}

class _WeeklyScreenState extends State<WeeklyScreen> {
  Future<List<dynamic>> getData() async {
    var url = Uri.https(
        'ergast.com', 'api/f1/current/last/results.json', {'q': '{http}'});

    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;

      return jsonResponse["MRData"]["RaceTable"]["Races"].toList();
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return _error();
    }
  }

  String season = "..";
  String round = "..";

  Future<void> initFunc() async {
    var data = await getData();
    setState(() {
      season = data[0]["season"];
      round = data[0]["round"];
    });
  }

  @override
  void initState() {
    super.initState();
    initFunc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: AppColors.primaryColorLight,
          title: _buildTopHeader()),
      body: PlaneIndicator(
        child: Column(
          children: [
            _buildBottomHeader(),
            Expanded(
              child: FutureBuilder(
                future: getData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      color: AppColors.white,
                      child: const Center(
                        child: DetailSkeleton(),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return _error();
                  } else {
                    var data = snapshot.data!;
                    return data.isEmpty ? _error() : _list(data);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container _buildTopHeader() {
    return Container(
      color: AppColors.primaryColorLight,
      padding: const EdgeInsets.all(5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 50,
            child: Center(
              child: Text(
                "Season - $season",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.black,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 100,
            child: Center(
              child: Text(
                "Round Number - $round",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.black,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  SizedBox _buildBottomHeader() {
    return SizedBox(
      child: Container(
        color: AppColors.primaryColorLight,
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 50,
              child: Center(
                child: Text(
                  "Position",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 50,
              child: Center(
                child: Text(
                  "Driver",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 50,
              child: Center(
                child: Text(
                  "Constructor",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 50,
              child: Center(
                child: Text(
                  "Points",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 15,
                    // center
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container _list(List<dynamic> data) {
    return Container(
      color: AppColors.white,
      child: Center(
        child: ListView.builder(
          itemCount: data[0]["Results"].length,
          itemBuilder: (context, index) {
            return _card(context, data, index);
          },
        ),
      ),
    );
  }

  _card(BuildContext context, List<dynamic> data, int index) {
    return Card(
      color: index % 2 != 0 ? AppColors.primaryColorTint20 : AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: const EdgeInsets.all(7),
      child: InkWell(
        onTap: () => showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              insetPadding: EdgeInsets.all(0),
              content: WeeklyDialog(
                eventName: data[0]["raceName"],
                eventDate: data[0]["date"].toString().split("-")[0],
                driverPosition: data[0]["Results"][index]["position"],
                driverName: data[0]["Results"][index]["Driver"]["givenName"] +
                    " " +
                    data[0]["Results"][index]["Driver"]["familyName"],
                driverGrid: data[0]["Results"][index]["grid"],
                driverfastestLap: data[0]["Results"][index]["FastestLap"]
                        ["rank"] +
                    " " +
                    data[0]["Results"][index]["FastestLap"]["lap"] +
                    " " +
                    data[0]["Results"][index]["FastestLap"]["Time"]["time"],
                isFinished: data[0]["Results"][index]["status"] == "Finished"
                    ? true
                    : false,
                driverTime: data[0]["Results"][index]["Time"] == null
                    ? "N/A"
                    : data[0]["Results"][index]["Time"]["time"],
                driverSpeed: data[0]["Results"][index]["FastestLap"]
                        ["AverageSpeed"]["speed"] +
                    " " +
                    data[0]["Results"][index]["FastestLap"]["AverageSpeed"]
                        ["units"],
              ),
            );
          },
        ),
        child: _line(index, data),
      ),
    );
  }

  Container _line(int index, List<dynamic> data) {
    return Container(
      child: Material(
        color: index % 2 != 0 ? AppColors.primaryColorTint20 : AppColors.white,
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _position(data, index),
              _driverName(data, index),
              _constructor(data, index),
              _points(data, index),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox _points(List<dynamic> data, int index) {
    return SizedBox(
      width: 50,
      height: 80,
      child: Center(
        child: Text(
          data[0]["Results"][index]["points"],
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.black,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  SizedBox _constructor(List<dynamic> data, int index) {
    return SizedBox(
      width: 90,
      height: 80,
      child: Center(
        child: Text(
          data[0]["Results"][index]["Constructor"]["name"],
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.black,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  SizedBox _driverName(List<dynamic> data, int index) {
    return SizedBox(
      width: 100,
      height: 80,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            data[0]["Results"][index]["Driver"]["givenName"],
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.black,
              fontSize: 15,
            ),
          ),
          Text(
            data[0]["Results"][index]["Driver"]["familyName"],
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.black,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Container _position(List<dynamic> data, int index) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.black,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Center(
        child: Text(
          data[0]["Results"][index]["position"],
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 12,
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
