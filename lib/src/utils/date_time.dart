extension SameDay on DateTime {
  bool sameDayAs(DateTime other) =>
      year == other.year && month == other.month && day == other.day;

  DateTime noTime() => DateTime(year, month, day);
}
