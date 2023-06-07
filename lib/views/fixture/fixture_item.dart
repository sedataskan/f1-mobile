import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import '../../constants/colors.dart';

class FixtureItem extends StatefulWidget {
  const FixtureItem(
      {super.key,
      required this.position,
      required this.driverName,
      required this.constructorName,
      required this.points,
      required this.wikipedia});

  final String position;
  final String driverName;
  final String constructorName;
  final String points;
  final String wikipedia;

  @override
  State<FixtureItem> createState() => _FixtureItemState();
}

class _FixtureItemState extends State<FixtureItem> {
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
          about = jsonResponse["description"];
        });
      } else {
        print('Request failed with status: ${response.statusCode}.');
        if (!isTriedGetData) {
          getData(widget.driverName);
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
    return Scaffold(
      appBar: buildAppBar(context),
      backgroundColor: AppColors.primaryColorLight,
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          Center(
            child: Stack(
              children: [
                ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: imageLink,
                    width: 200,
                    height: 200,
                    fit: BoxFit.contain,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) =>
                            CircularProgressIndicator(
                                value: downloadProgress.progress),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 24),
          buildName(widget.driverName, widget.constructorName),
          const SizedBox(height: 24),
          NumbersWidget(position: widget.position, points: widget.points),
          const SizedBox(height: 48),
          buildAbout(about),
        ],
      ),
    );
  }

  Widget buildName(name, constructor) => Column(
        children: [
          Text(
            name,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            constructor,
            style: TextStyle(color: AppColors.black.withOpacity(0.5)),
          )
        ],
      );

  Widget buildAbout(about) => Container(
        padding: EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              about,
              style: TextStyle(fontSize: 16, height: 1.4),
            ),
          ],
        ),
      );
}

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;

  const ButtonWidget({
    Key? key,
    required this.text,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          shape: StadiumBorder(),
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        ),
        child: Text(text),
        onPressed: onClicked,
      );
}

AppBar buildAppBar(BuildContext context) {
  return AppBar(
    leading: BackButton(
      color: Colors.black,
    ),
    backgroundColor: AppColors.primaryColorTint20,
    elevation: 0,
  );
}

class NumbersWidget extends StatelessWidget {
  const NumbersWidget({
    Key? key,
    required this.position,
    required this.points,
  }) : super(key: key);
  final String position;
  final String points;
  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          buildButton(context, "#" + position, 'Position'),
          buildDivider(),
          buildButton(context, points, 'Points'),
        ],
      );
  Widget buildDivider() => Container(
        height: 24,
        child: VerticalDivider(),
      );

  Widget buildButton(BuildContext context, String value, String text) =>
      MaterialButton(
        padding: EdgeInsets.symmetric(vertical: 4),
        onPressed: () {},
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              value,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            SizedBox(height: 2),
            Text(
              text,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
}
