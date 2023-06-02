import 'package:flutter/material.dart';

class Race {
  /// Creates a meeting class with required details.
  Race(this.eventName, this.from, this.to, this.background, this.isAllDay);

  /// Event name which is equivalent to subject property of [Appointment].
  String eventName;

  /// From which is equivalent to start time property of [Appointment].
  DateTime from;

  /// To which is equivalent to end time property of [Appointment].
  DateTime to;

  /// Background which is equivalent to color property of [Appointment].
  Color background;

  /// IsAllDay which is equivalent to isAllDay property of [Appointment].
  bool isAllDay;

  getEventName() {
    return eventName;
  }

  getFrom() {
    return from;
  }

  getTo() {
    return to;
  }
}
