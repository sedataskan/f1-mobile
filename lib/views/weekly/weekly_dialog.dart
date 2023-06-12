import 'package:f1_flutter/constants/colors.dart';
import 'package:flutter/material.dart';

class WeeklyDialog extends StatefulWidget {
  WeeklyDialog({
    super.key,
    required this.eventName,
    required this.eventDate,
    required this.driverName,
    required this.driverPosition,
    required this.driverGrid,
    required this.driverfastestLap,
    required this.isFinished,
    required this.driverTime,
    required this.driverSpeed,
  });

  final String eventName;
  final String driverPosition;
  final String eventDate;
  final String driverName;
  final String driverGrid;
  final String driverfastestLap;
  final String driverTime;
  final String driverSpeed;
  final bool isFinished;

  @override
  State<StatefulWidget> createState() => _WeeklyDialogState();
}

class _WeeklyDialogState extends State<WeeklyDialog> {
  initState() {
    super.initState();
    getData();
  }

  bool isTriedGetData = false;

  Future<void> getData() async {}

  @override
  Widget build(BuildContext context) {
    return _dialog(
        widget.eventName,
        widget.driverPosition,
        widget.eventDate,
        widget.driverName,
        widget.driverGrid,
        widget.driverfastestLap,
        widget.driverTime,
        widget.driverSpeed,
        widget.isFinished);
  }

  _dialog(eventName, driverPosition, eventDate, driverName, driverGrid,
      driverfastestLap, driverTime, driverSpeed, isFinished) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(height: 10),
          _event(eventName, eventDate),
          SizedBox(height: 10),
          _driver(driverPosition, driverName),
          SizedBox(height: 10),
          _grid(driverGrid, driverPosition),
          SizedBox(height: 10),
          _time(driverTime),
          SizedBox(height: 10),
          _speed(driverSpeed),
          SizedBox(height: 10),
          _isFinished(isFinished),
          SizedBox(height: 10),
          Divider(
            color: AppColors.primaryColor,
            thickness: 2,
          ),
          SizedBox(height: 10),
          _fastestLap(driverfastestLap),
        ],
      ),
    );
  }

  Row _isFinished(isFinished) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Text(
            isFinished ? "Finished" : "Not Finished",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
        Icon(
          isFinished ? Icons.flag : Icons.flag_outlined,
          color: isFinished ? AppColors.future : AppColors.past,
          size: 20,
        ),
      ],
    );
  }

  Row _speed(driverSpeed) {
    return Row(
      children: [
        Text(
          "Speed: ",
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        Text(
          driverSpeed,
          style: TextStyle(fontSize: 15),
        ),
      ],
    );
  }

  Row _time(driverTime) {
    return Row(
      children: [
        Text(
          "Time: ",
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        Text(
          driverTime + " s",
          style: TextStyle(fontSize: 15),
        ),
      ],
    );
  }

  Row _grid(driverGrid, driverPosition) {
    return Row(
      children: [
        Text(
          "Grid: ",
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        Text(
          driverGrid,
          style: TextStyle(fontSize: 15),
        ),
        Icon(
          //if grid is bigger than position arrow up, else arrow down
          int.parse(driverGrid) > int.parse(driverPosition)
              ? Icons.arrow_upward
              : int.parse(driverGrid) == int.parse(driverPosition)
                  ? Icons.horizontal_rule
                  : Icons.arrow_downward,
          color: int.parse(driverGrid) > int.parse(driverPosition)
              ? AppColors.future
              : int.parse(driverGrid) == int.parse(driverPosition)
                  ? AppColors.today
                  : AppColors.past,
        ),
      ],
    );
  }

  Row _driver(driverPosition, driverName) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Text(
            "#" + driverPosition,
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
        ),
        Text(
          driverName,
          style: TextStyle(fontSize: 17),
        ),
      ],
    );
  }

  Row _event(eventName, eventDate) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          eventName,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          eventDate,
          style: TextStyle(fontSize: 15),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Column _fastestLap(driverfastestLap) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              "Fastest Lap ",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(height: 5),
        Row(
          children: [
            Text(
              "    Rank: ",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Text(
              driverfastestLap.split(" ")[0],
              style: TextStyle(fontSize: 15),
            ),
            Icon(
              //if rank == 1 then its color is purple else its color is grey
              Icons.timer,
              color: driverfastestLap.split(" ")[0] == "1"
                  ? AppColors.purple
                  : AppColors.primaryColor,
              size: 20,
            ),
          ],
        ),
        Row(
          children: [
            Text(
              "    Lap: ",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Text(
              driverfastestLap.split(" ")[1],
              style: TextStyle(fontSize: 15),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              "    Time: ",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Text(
              driverfastestLap.split(" ")[2] + " s",
              style: TextStyle(fontSize: 15),
            ),
          ],
        ),
      ],
    );
  }
}
