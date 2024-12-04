extension SameDay on DateTime {
  bool isSameDayAs(DateTime other) {
    return day == other.day && month == other.month && year == other.year;
  }
}
