class DateFormatter {
  static String getFormattedDate(DateTime dateTime) {
    List<String> months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];
    return dateTime.day.toString() +
        " " +
        months[dateTime.month - 1] +
        " " +
        dateTime.year.toString();
  }

  static String getFormattedTime(DateTime dateTime) {
    return dateTime.hour.toString() +
        ":" +
        dateTime.minute.toString().padLeft(2, "0");
  }
}
