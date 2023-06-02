import 'package:f1_flutter/views/schedule/models/race.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class RaceDataSource extends CalendarDataSource {
  RaceDataSource(List<Race> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return _getRaceData(index).from;
  }

  @override
  DateTime getEndTime(int index) {
    return _getRaceData(index).to;
  }

  @override
  String getSubject(int index) {
    return _getRaceData(index).eventName;
  }

  @override
  Color getColor(int index) {
    return _getRaceData(index).background;
  }

  @override
  bool isAllDay(int index) {
    return _getRaceData(index).isAllDay;
  }

  Race _getRaceData(int index) {
    final dynamic race = appointments![index];
    late final Race raceData;
    if (race is Race) {
      raceData = race;
    }

    return raceData;
  }
}
