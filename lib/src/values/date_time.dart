// Copyright (c) 2023 Brian Tutovic All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:intl/intl.dart';

import '../calendar_parameter.dart';
import '../calendar_parameter_value.dart';
import '../calendar_value.dart';
import 'date.dart';
import 'time.dart';

const _defaultFixed = true;

/// RFC2445 Section 4.3.5
class DateTimeValue extends CalendarValue<DateTime> {
  /// If set to [true], will fix the time
  /// value to either the supplied [timeZoneIdentifier]
  /// or to the `UTC` timezone by default
  ///
  /// Defaults to [true]
  final bool fixed;

  /// The [tzId] value of a [TimeZoneComponent]
  /// located inside the current calendar
  final String? timeZoneIdentifier;

  final DateValue _dateValue;
  final TimeValue _timeValue;

  DateTimeValue(
    DateTime value, {
    this.fixed = _defaultFixed,
    this.timeZoneIdentifier,
  })  : _dateValue = DateValue(value),
        _timeValue = TimeValue(
          value,
          fixed: fixed,
          timeZoneIdentifier: timeZoneIdentifier,
        ),
        super(value, ValueType.dateTime);

  factory DateTimeValue.fromCrawledStringValue(
    String value, {
    String? timeZoneIdentifier,
  }) {
    final normalizedValue = value.trim().toUpperCase();

    late final String parseValue;
    try {
      parseValue =
          "${normalizedValue.substring(0, 4)}.${normalizedValue.substring(4, 6)}.${normalizedValue.substring(6, 8)}T${normalizedValue.substring(9, 11)}.${normalizedValue.substring(11, 13)}.${normalizedValue.substring(13, 15)}";
    } catch (e) {
      // No time provided
      parseValue =
          "${normalizedValue.substring(0, 4)}.${normalizedValue.substring(4, 6)}.${normalizedValue.substring(6, 8)}T00.00.00";
    }

    return DateTimeValue(
      DateFormat("yyyy.MM.dd'T'HH.mm.ss").parse(
        parseValue,
        normalizedValue.toUpperCase().endsWith("Z"),
      ),
      fixed: normalizedValue.toUpperCase().endsWith("Z") ||
          timeZoneIdentifier != null,
      timeZoneIdentifier: timeZoneIdentifier,
    );
  }

  @override
  String sanitizeToString() {
    return "${_dateValue}T$_timeValue";
  }

  @override
  List<CalendarParameter> getInlineParameters() {
    return [
      ..._dateValue.getInlineParameters(),
      ..._timeValue.getInlineParameters()
    ];
  }
}

class DateTimeParameterValue extends DateTimeValue with CalendarParameterValue {
  DateTimeParameterValue(
    DateTime value, {
    bool fixed = _defaultFixed,
    String? timeZoneIdentifier,
  }) : super(
          value,
          fixed: fixed,
          timeZoneIdentifier: timeZoneIdentifier,
        );
}
