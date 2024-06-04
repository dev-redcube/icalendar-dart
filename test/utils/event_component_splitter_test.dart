import 'package:icalendar/icalendar.dart';
import 'package:test/test.dart';

const ical = """
    BEGIN:VCALENDAR
    PRODID:IRGENDWAS
    VERSION:2.0
    BEGIN:VEVENT
    UID:myUid1
    DTSTART:20240602T120000
    DTEND:20240602T140000
    SUMMARY:Testevent
    END:EVENT
    END:VCALENDAR
    """;

void main() {
  final components = ICalendar.fromICalendarString(ical);
  final event = components.first.components.first as EventComponent;

  test("Split Component without repeat rules", () {
    final splitUp = event.splitComponent();
    expect(splitUp, hasLength(1));
  });

  group("RecurrenceDateTimes", () {
    test("One RecurrenceDateTime with one value", () {
      final withRule = event.copyWith(
        recurrenceDateTimes: [
          RecurrenceDateTimesProperty([
            DateTime(2024, 06, 03),
          ]),
        ],
      );

      final splitUp = withRule.splitComponent();

      expect(splitUp, hasLength(2));
      expect(splitUp[1].recurrenceDateTimes, null);
      expect(splitUp[1].dateTimeStart!.value.value,
          DateTime.parse("2024-06-02T12:00:00.000"));

      expect(splitUp.first.recurrenceDateTimes, null);
      expect(splitUp.first.dateTimeStart!.value.value,
          DateTime.parse("2024-06-03T12:00:00.000"));
    });

    test("Two RecurrenceDateTimes", () {
      final withRule = event.copyWith(
        recurrenceDateTimes: [
          RecurrenceDateTimesProperty([
            DateTime(2024, 06, 03),
          ]),
          RecurrenceDateTimesProperty([
            DateTime(2024, 06, 04),
            DateTime(2024, 06, 05),
          ]),
        ],
      );

      final splitUp = withRule.splitComponent();

      expect(splitUp, hasLength(4));
    });
  });

  group("RRULE", () {
    test("RRULE with one rule", () {
      final withRule = event.copyWith(recurrenceRules: [
        RecurrenceRuleProperty(
            frequency: RecurrenceFrequency.daily, interval: 2, count: 5),
      ]);

      final splitUp = withRule.splitComponent();

      expect(splitUp, hasLength(5));

      // RecurrenceRules are removed
      expect(splitUp.where((e) => e.recurrenceRules != null), hasLength(0));
    });

    test("RRULE with two rules", () {
      final withRule = event.copyWith(recurrenceRules: [
        RecurrenceRuleProperty(
            frequency: RecurrenceFrequency.daily, interval: 2, count: 5),
        RecurrenceRuleProperty(frequency: RecurrenceFrequency.weekly, count: 3),
      ]);

      final splitUp = withRule.splitComponent();

      expect(splitUp, hasLength(8));
    });

    test("RRULE with EXDATE", () {
      final withRule = event.copyWith(recurrenceRules: [
        RecurrenceRuleProperty(
            frequency: RecurrenceFrequency.daily, interval: 2, count: 5),
      ], exceptionDateTimes: [
        ExceptionDateTimesProperty([DateTime(2024, 06, 04)],
            valueType: ValueType.date),
      ]);

      final splitUp = withRule.splitComponent();

      expect(splitUp, hasLength(4));
    });

    test("RRULE with until", () {
      final withRule = event.copyWith(recurrenceRules: [
        RecurrenceRuleProperty(
            frequency: RecurrenceFrequency.daily,
            interval: 2,
            until: DateTime(2024, 06, 10)),
      ], exceptionDateTimes: [
        ExceptionDateTimesProperty([DateTime(2024, 06, 20)],
            valueType: ValueType.date),
      ]);

      final splitUp = withRule.splitComponent();

      expect(splitUp, hasLength(5));
    });

    test("RRULE until date and exception", () {
      final withRule = event.copyWith(recurrenceRules: [
        RecurrenceRuleProperty(
            frequency: RecurrenceFrequency.daily,
            interval: 2,
            until: DateTime(2024, 06, 10)),
      ], exceptionDateTimes: [
        ExceptionDateTimesProperty([DateTime(2024, 06, 04)],
            valueType: ValueType.date),
      ]);

      final splitUp = withRule.splitComponent();

      expect(splitUp, hasLength(4));
    });

    test("RRULE without end", () {
      final withRule = event.copyWith(recurrenceRules: [
        RecurrenceRuleProperty(
          frequency: RecurrenceFrequency.daily,
          interval: 2,
        )
      ]);

      final splitUp = withRule.splitComponent();

      expect(splitUp, hasLength(365));
    });
  });

  test("RRULE and RecurrenceDateTimes", () {
    final withRule = event.copyWith(
      recurrenceDateTimes: [
        RecurrenceDateTimesProperty([
          DateTime(2024, 06, 05),
        ]),
      ],
      recurrenceRules: [
        // Every 2 days, 5 times
        RecurrenceRuleProperty(
          frequency: RecurrenceFrequency.daily,
          interval: 2,
          count: 5,
        ),
      ],
    );

    final splitUp = withRule.splitComponent();

    expect(splitUp, hasLength(6));

    expect(splitUp.where((e) => e.recurrenceRules != null), hasLength(0));
    expect(splitUp.where((e) => e.recurrenceDateTimes != null), hasLength(0));
    expect(splitUp.where((e) => e.recurrenceId != null), hasLength(0));
    expect(splitUp.where((e) => e.exceptionDateTimes != null), hasLength(0));
    expect(splitUp.where((e) => e.exceptionRules != null), hasLength(0));
  });
}
