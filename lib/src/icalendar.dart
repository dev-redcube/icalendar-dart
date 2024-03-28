// Copyright (c) 2023 Brian Tutovic All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// ignore_for_file: avoid_print

import 'package:equatable/equatable.dart';

import 'calendar_component.dart';
import 'calendar_property.dart';
import 'calendar_value.dart';
import 'components/event.dart';
import 'components/free_busy.dart';
import 'components/journal.dart';
import 'components/time_zone.dart';
import 'components/todo.dart';
import 'models/crawled_block.dart';
import 'properties/calendar_scale.dart';
import 'properties/method.dart';
import 'properties/product_identifier.dart';
import 'properties/version.dart';
import 'utils/deserializer.dart';

/// RFC2445 Section 4.4
class ICalendar extends Equatable {
  final ProductIdentifierProperty productIdentifier;
  final VersionProperty version;
  final CalendarScaleProperty? calendarScale;
  final MethodProperty? method;

  final List<CalendarComponent> _components = [];

  ICalendar({
    required this.productIdentifier,
    required this.version,
    this.calendarScale,
    this.method,
  });

  static List<ICalendar> fromICalendarString(String ical) {
    return crawlICalendarLines(ical.trim().split("\n"))
        .map((e) => ICalendar.fromCrawledBlock(e))
        .toList();
  }

  static List<ICalendar> fromICalendarLines(List<String> lines) {
    return crawlICalendarLines(lines)
        .map((e) => ICalendar.fromCrawledBlock(e))
        .toList();
  }

  factory ICalendar.fromCrawledBlock(CrawledBlock block) {
    assert(
      block.blockName.toUpperCase() == "VCALENDAR",
      "Received invalid block: ${block.blockName}",
    );

    ProductIdentifierProperty? productIdentifier;
    VersionProperty? version;
    CalendarScaleProperty? calendarScale;
    MethodProperty? method;

    for (var e in block.properties) {
      switch (e.name.toUpperCase()) {
        case "PRODID":
          productIdentifier = ProductIdentifierProperty.fromCrawledProperty(e);
          break;
        case "VERSION":
          version = VersionProperty.fromCrawledProperty(e);
          break;
        case "CALSCALE":
          calendarScale = CalendarScaleProperty.fromCrawledProperty(e);
          break;
        case "METHOD":
          method = MethodProperty.fromCrawledProperty(e);
          break;
        default:
          print("Unknown property encountered in ICalendar Object: ${e.name}");
      }
    }

    assert(
      productIdentifier != null && version != null,
      "[productIdentifier] and [version] cannot be null",
    );

    final ical = ICalendar(
      productIdentifier: productIdentifier!,
      version: version!,
      calendarScale: calendarScale,
      method: method,
    );

    for (var e in block.nestedBlocks) {
      switch (e.blockName.toUpperCase()) {
        case "VEVENT":
          ical.addComponent(EventComponent.fromCrawledBlock(e));
          break;
        case "VTODO":
          ical.addComponent(TodoComponent.fromCrawledBlock(e));
          break;
        case "VJOURNAL":
          ical.addComponent(JournalComponent.fromCrawledBlock(e));
          break;
        case "VFREEBUSY":
          ical.addComponent(FreeBusyComponent.fromCrawledBlock(e));
          break;
        case "VTIMEZONE":
          ical.addComponent(TimeZoneComponent.fromCrawledBlock(e));
          break;
        default:
          print(
              "Unknown component encountered in ICalendar Object: ${e.blockName}");
      }
    }

    return ical;
  }

  ICalendar addComponent(CalendarComponent component) {
    _components.add(component);
    return this;
  }

  void validate() {
    assert(components.isNotEmpty, "Must have at least 1 component");
  }

  @override
  String toString() {
    validate();
    final res = StringBuffer("BEGIN:VCALENDAR\n");
    final props = _properties;
    res.writeAll(props, "\n");
    if (props.isNotEmpty) res.write("\n");
    res.writeAll(components);
    res.writeln("END:VCALENDAR");
    return res.toString();
  }

  List<CalendarProperty<CalendarValue>> get _properties => [
        productIdentifier,
        version,
        calendarScale ?? CalendarScaleProperty(CalendarScaleType.gregorian),
        if (method != null) method!,
      ];

  List<CalendarComponent> get components => _components;

  @override
  List<Object?> get props => [_properties, components];
}
