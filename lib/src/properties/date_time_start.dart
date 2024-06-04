// Copyright (c) 2023 Brian Tutovic All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import '../calendar_parameter.dart';
import '../calendar_parameter_value.dart';
import '../calendar_property.dart';
import '../calendar_value.dart';
import '../models/crawled_property.dart';
import '../parameters/time_zone_identifier.dart';
import '../parameters/value_data_type.dart';
import '../values/date.dart';
import '../values/date_time.dart';

/// RFC2445 Section 4.8.2.4
class DateTimeStartProperty extends CalendarProperty<CalendarValue<DateTime>> {
  /// Can either be date or dateTime
  ///
  /// Defaults to dateTime
  final ValueType valueType;

  final String? timeZoneIdentifier;

  DateTimeStartProperty(
    DateTime value, {
    this.valueType = ValueType.dateTime,
    this.timeZoneIdentifier,
  })  : assert(
          valueType == ValueType.date || valueType == ValueType.dateTime,
          "valueType must either be date or dateTime",
        ),
        super(
          "DTSTART",
          valueType == ValueType.date ? DateValue(value) : DateTimeValue(value),
        );

  factory DateTimeStartProperty.fromCrawledProperty(CrawledProperty property) {
    assert(
      property.name.toUpperCase() == "DTSTART",
      "Received invalid property: ${property.name}",
    );

    return DateTimeStartProperty(
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

  DateTimeStartProperty copyWith({
    DateTime? value,
    ValueType? valueType,
    String? timeZoneIdentifier,
  }) =>
      DateTimeStartProperty(
        value ?? this.value.value,
        valueType: valueType ?? this.valueType,
        timeZoneIdentifier: timeZoneIdentifier ?? this.timeZoneIdentifier,
      );
}
