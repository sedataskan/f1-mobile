import 'package:f1_flutter/constants/colors.dart';
import 'package:f1_flutter/views/components/schedule_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'champions_item.dart';

class ChampionsScreen extends StatefulWidget {
  const ChampionsScreen({super.key});
  @override
  State<ChampionsScreen> createState() => _ChampionsScreenState();
}

class _ChampionsScreenState extends State<ChampionsScreen> {
  Future<List<dynamic>> getData() async {
    var url = Uri.https('ergast.com', '/api/f1/driverStandings/1.json',
        {'q': '{http}', 'limit': '500'});

    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      return jsonResponse["MRData"]["StandingsTable"]["StandingsLists"]
          .reversed
          .toList();
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: AppColors.primaryColorLight, title: _buildHeader()),
      body: RefreshIndicator(
        color: AppColors.primaryColor,
        onRefresh: () async {
          setState(() {
            getData();
          });
        },
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
    );
  }

  Container _list(List<dynamic> data) {
    return Container(
      color: AppColors.white,
      child: Center(
        child: ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            return Container(
              color: index % 2 != 0
                  ? AppColors.primaryColorTint20
                  : AppColors.white,
              padding: const EdgeInsets.all(10.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChampionsItem(
                        driverName: data[index]["DriverStandings"][0]["Driver"]
                                ["givenName"] +
                            " " +
                            data[index]["DriverStandings"][0]["Driver"]
                                ["familyName"],
                        constructorName: data[index]["DriverStandings"][0]
                            ["Constructors"][0]["name"],
                        season: data[index]["season"],
                        points: data[index]["DriverStandings"][0]["points"],
                        wikipedia: data[index]["DriverStandings"][0]["Driver"]
                            ["url"],
                      ),
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _season(data, index),
                    _name(data, index),
                    _constructor(data, index),
                    _points(data, index),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Container _season(List<dynamic> data, int index) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.black,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Center(
        child: Text(
          data[index]["season"],
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  SizedBox _name(List<dynamic> data, int index) {
    return SizedBox(
      width: 100,
      height: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            data[index]["DriverStandings"][0]["Driver"]["givenName"],
            style: const TextStyle(
              color: AppColors.black,
              fontSize: 15,
            ),
          ),
          Text(
            data[index]["DriverStandings"][0]["Driver"]["familyName"],
            style: const TextStyle(
              color: AppColors.black,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  SizedBox _constructor(List<dynamic> data, int index) {
    return SizedBox(
      width: 90,
      height: 100,
      child: Center(
        child: Text(
          data[index]["DriverStandings"][0]["Constructors"][0]["name"],
          style: const TextStyle(
            color: AppColors.black,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  SizedBox _points(List<dynamic> data, int index) {
    return SizedBox(
      width: 50,
      height: 100,
      child: Center(
        child: Text(
          data[index]["DriverStandings"][0]["points"],
          style: const TextStyle(
            color: AppColors.black,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Container _buildHeader() {
    return Container(
      color: AppColors.primaryColorLight,
      padding: const EdgeInsets.all(5.0),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 50,
            height: 50,
            child: Center(
              child: Text(
                "Year",
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 100,
            height: 100,
            child: Center(
              child: Text(
                "Driver",
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 90,
            height: 100,
            child: Center(
              child: Text(
                "Constructor",
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 50,
            height: 100,
            child: Center(
              child: Text(
                "Points",
                style: TextStyle(
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

  _error() {
    return Container(
      color: AppColors.white,
      child: Center(child: Image.asset("assets/images/error.png")),
    );
  }
}
