import '../calendar_parameter.dart';
import '../calendar_parameter_value.dart';
import '../calendar_property.dart';
import '../calendar_value.dart';
import '../models/crawled_property.dart';
import '../parameters/time_zone_identifier.dart';
import '../parameters/value_data_type.dart';
import '../values/date.dart';
import '../values/date_time.dart';

/// RFC2445 Section 4.8.2.3
class DateTimeDueProperty extends CalendarProperty<CalendarValue<DateTime>> {
  /// Can either be date or dateTime
  ///
  /// Defaults to dateTime
  final ValueType valueType;

  final String? timeZoneIdentifier;

  DateTimeDueProperty(
    DateTime value, {
    this.valueType = ValueType.dateTime,
    this.timeZoneIdentifier,
  })  : assert(
          valueType == ValueType.date || valueType == ValueType.dateTime,
          "valueType must either be date or dateTime",
        ),
        super(
          "DUE",
          valueType == ValueType.date ? DateValue(value) : DateTimeValue(value),
        );

  factory DateTimeDueProperty.fromCrawledProperty(CrawledProperty property) {
    assert(
      property.name.toUpperCase() == "DUE",
      "Received invalid property: ${property.name}",
    );

    return DateTimeDueProperty(
      DateTimeValue.fromCrawledStringValue(property.value).value,
      valueType: property.parameters
              .where(ValueDataTypeParameter.testCrawledParameter)
              .isEmpty
          ? ValueType.dateTime
          : property.parameters
              .where(ValueDataTypeParameter.testCrawledParameter)
              .map((e) => ValueDataTypeParameter.fromCrawledParameter(e))
              .first
              .type,
      timeZoneIdentifier: property.parameters
              .where(TimeZoneIdentifierParameter.testCrawledParameter)
              .isEmpty
          ? null
          : property.parameters
              .where(TimeZoneIdentifierParameter.testCrawledParameter)
              .map((e) => TimeZoneIdentifierParameter.fromCrawledParameter(e))
              .first
              .timeZoneIdentifier,
    );
  }

  @override
  List<CalendarParameter<CalendarParameterValue>> getParameters() {
    return [
      ValueDataTypeParameter(valueType),
      if (timeZoneIdentifier != null)
        TimeZoneIdentifierParameter(timeZoneIdentifier!),
    ];
  }
}
