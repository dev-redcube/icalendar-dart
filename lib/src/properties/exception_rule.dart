import '../calendar_parameter.dart';
import '../calendar_parameter_value.dart';
import '../calendar_property.dart';
import '../calendar_value.dart';
import '../models/recurrence_rule.dart';
import '../values/recurrence_rule.dart';

/// RFC2445 Section 4.8.5.2
class ExceptionRuleProperty extends CalendarProperty<RecurrenceRuleValue> {
  ExceptionRuleProperty({
    required RecurrenceFrequency frequency,
    int interval = RecurrenceRule.defaultInterval,
    RecurrenceWeekday startOfWorkWeek = RecurrenceRule.defaultStartOfWorkWeek,
    DateTime? until,
    int? count,
    Set<int>? bySeconds,
    Set<int>? byMinutes,
    Set<int>? byHours,
    Set<RecurranceByDay>? byDays,
    Set<int>? byMonthDays,
    Set<int>? byYearDays,
    Set<int>? byWeekNumbers,
    Set<int>? byMonths,
    Set<int>? bySetPositions,
  }) : super(
          "EXRULE",
          RecurrenceRuleValue(
            frequency: frequency,
            interval: interval,
            startOfWorkWeek: startOfWorkWeek,
            until: until,
            count: count,
            bySeconds: bySeconds,
            byMinutes: byMinutes,
            byHours: byHours,
            byDays: byDays,
            byMonthDays: byMonthDays,
            byYearDays: byYearDays,
            byWeekNumbers: byWeekNumbers,
            byMonths: byMonths,
            bySetPositions: bySetPositions,
          ),
        );

  @override
  T deserialize<T extends CalendarProperty<CalendarValue>>(String ical) {
    // TODO: implement deserialize
    throw UnimplementedError();
  }

  @override
  List<CalendarParameter<CalendarParameterValue>> getParameters() {
    return [];
  }
}