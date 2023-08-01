import 'package:f1_flutter/constants/colors.dart';
import 'package:f1_flutter/views/components/indicator.dart';
import 'package:f1_flutter/views/components/skeleton.dart';
import 'package:f1_flutter/views/fixture/fixture_item.dart';
import 'package:f1_flutter/views/weekly/weekly.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class FixtureScreen extends StatefulWidget {
  const FixtureScreen({super.key});
  @override
  State<FixtureScreen> createState() => _FixtureScreenState();
}

class _FixtureScreenState extends State<FixtureScreen> {
  Future<List<dynamic>> getData() async {
    var url = Uri.https(
        'ergast.com', '/api/f1/current/driverStandings.json', {'q': '{http}'});

    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;

      return jsonResponse["MRData"]["StandingsTable"]["StandingsLists"]
          .toList();
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
      floatingActionButton: FloatingActionButton.extended(
        //go to weekly screen when pressed
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const WeeklyScreen(),
            ),
          );
        },
        label: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Weekly"),
            const SizedBox(width: 10),
            Icon(Icons.filter_list),
          ],
        ),
      ),
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

  Container _list(List<dynamic> data) {
    return Container(
      color: AppColors.white,
      child: Center(
        child: ListView.builder(
          itemCount: data[0]["DriverStandings"].length,
          itemBuilder: (context, index) {
            return _card(data, index);
          },
        ),
      ),
    );
  }

  _card(data, index) {
    return Card(
      color: index % 2 != 0 ? AppColors.primaryColorTint20 : AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: const EdgeInsets.all(7),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FixtureItem(
                position: data[0]["DriverStandings"][index]["position"],
                driverName: data[0]["DriverStandings"][index]["Driver"]
                        ["givenName"] +
                    " " +
                    data[0]["DriverStandings"][index]["Driver"]["familyName"],
                constructorName: data[0]["DriverStandings"][index]
                    ["Constructors"][0]["name"],
                points: data[0]["DriverStandings"][index]["points"],
                wikipedia: data[0]["DriverStandings"][index]["Driver"]["url"],
              ),
            ),
          );
        },
        child: _line(data, index),
      ),
    );
  }

  Container _line(List<dynamic> data, int index) {
    return Container(
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
    );
  }

  SizedBox _points(List<dynamic> data, int index) {
    return SizedBox(
      width: 50,
      height: 80,
      child: Center(
        child: Text(
          data[0]["DriverStandings"][index]["points"],
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
          data[0]["DriverStandings"][index]["Constructors"][0]["name"],
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
            data[0]["DriverStandings"][index]["Driver"]["givenName"],
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.black,
              fontSize: 15,
            ),
          ),
          Text(
            data[0]["DriverStandings"][index]["Driver"]["familyName"],
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
          data[0]["DriverStandings"][index]["position"],
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 12,
          ),
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

  _error() {
    return Container(
      color: AppColors.white,
      child: Center(child: Image.asset("assets/images/error.png")),
    );
  }
}
