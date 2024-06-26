// Copyright (c) 2023 Brian Tutovic All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import '../calendar_parameter.dart';
import '../models/craweled_parameter.dart';
import '../values/text.dart';

/// RFC2445 Section 4.2.19
class TimeZoneIdentifierParameter
    extends CalendarParameter<TextParameterValue> {
  final String timeZoneIdentifier;

  TimeZoneIdentifierParameter(
    this.timeZoneIdentifier,
  ) : super("TZID", TextParameterValue(timeZoneIdentifier));

  factory TimeZoneIdentifierParameter.fromCrawledParameter(
      CrawledParameter parameter) {
    assert(
      testCrawledParameter(parameter),
      "Received invalid parameter: ${parameter.name}",
    );
    return TimeZoneIdentifierParameter(
      TextValue.fromCrawledStringValue(parameter.value).value,
    );
  }

  static bool testCrawledParameter(CrawledParameter parameter) =>
      parameter.name.toUpperCase() == "TZID";
}
