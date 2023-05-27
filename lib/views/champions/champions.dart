import 'package:f1_flutter/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

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
            return Container(
              color: AppColors.white,
              child: Center(
                child: Text('Error occurred: ${snapshot.error}'),
              ),
            );
          } else {
            var data = snapshot.data!;
            return _list(data);
          }
        },
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
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
                  ),
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          data[index]["DriverStandings"][0]["Driver"]
                              ["givenName"],
                          style: const TextStyle(
                            color: AppColors.black,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          data[index]["DriverStandings"][0]["Driver"]
                              ["familyName"],
                          style: const TextStyle(
                            color: AppColors.black,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 90,
                    height: 100,
                    child: Center(
                      child: Text(
                        data[index]["DriverStandings"][0]["Constructors"][0]
                            ["name"],
                        style: const TextStyle(
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
                        data[index]["DriverStandings"][0]["points"],
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
          },
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
}
