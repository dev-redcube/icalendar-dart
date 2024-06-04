import 'package:icalendar/icalendar.dart';
import 'package:icalendar/src/utils/date_time.dart';
import 'package:rrule/rrule.dart' as rrule;

List<EventComponent> splitEventComponent(
  EventComponent component, {
  DateTime? rruleStart,
}) {
  final List<EventComponent> splitComponents = [];

  // recurrenceDateTimes
  if (component.recurrenceDateTimes != null) {
    splitComponents.addAll(_splitRecurrenceDates(component));
  }

  // RRULE
  if (component.recurrenceRules != null) {
    splitComponents.addAll(_splitRRule(component, rruleStart));
  } else {
    splitComponents.add(component.noRepeat());
  }

  return splitComponents;
}

List<EventComponent> _splitRecurrenceDates(EventComponent component) {
  assert(component.recurrenceDateTimes != null);
  assert(component.dateTimeStart != null);

  List<EventComponent> splitComponents = [];
  for (final dateTime in component.recurrenceDateTimes!) {
    for (final value in dateTime.value.values) {
      final newStartTime = component.dateTimeStart!.value.value.copyWith(
        year: value.value.year,
        month: value.value.month,
        day: value.value.day,
      );

      // end is set => Fixed end, no duration, fix
      DateTime? newEndTime;
      if (component.end != null) {
        newEndTime = newStartTime.add(component.computeDuration());
      }

      splitComponents.add(
        component.noRepeat().copyWith(
              dateTimeStart:
                  component.dateTimeStart!.copyWith(value: newStartTime),
              end: component.end?.copyWith(value: newEndTime),
            ),
      );
    }
  }

  return splitComponents;
}

/// Splits an EventComponent with RRULE into multiple
/// [start] defaults to 01.01.1970
List<EventComponent> _splitRRule(EventComponent component, DateTime? start) {
  List<EventComponent> splitComponents = [];
  List<DateTime> dates = [];

  for (final rule in component.recurrenceRules!) {
    final recur = rrule.RecurrenceRule.fromString(rule.toString());
    final recurrences = recur.getInstances(
      start: component.dateTimeStart!.value.value.copyWith(isUtc: true),
    );
    final Iterable<DateTime> exceptionDates = component.exceptionDateTimes
            ?.expand(
                (items) => items.value.value.map((e) => e.value.noTime())) ??
        [];

    for (final instance in recurrences) {
      final newStartTime = component.dateTimeStart!.value.value.copyWith(
        year: instance.year,
        month: instance.month,
        day: instance.day,
      );

      if (exceptionDates.contains(newStartTime.noTime())) continue;

      // end is set => Fixed end, no duration, fix
      DateTime? newEndTime;
      if (component.end != null) {
        newEndTime = newStartTime.add(component.computeDuration());
      }

      splitComponents.add(component.noRepeat().copyWith(
            dateTimeStart:
                component.dateTimeStart!.copyWith(value: newStartTime),
            end: component.end?.copyWith(value: newEndTime),
          ));
      dates.add(newStartTime);
    }
  }
  return splitComponents;
}
