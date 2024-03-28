# ICalendar Plugin

> [!NOTE]
> This package is made by Brian Tutovic on [GitLab](https://gitlab.com/powerbuilding/opensource/mobile/support-libraries/icalendar-dart).
> We made minor adjustments to the code to address some compatibility issues

Serializes and Deserializes ICalendar text. Offers 99+% coverage of the ICalendar RFC.

**Note:** Non-standard Parameters/Properties/Components (ie: x-\* named things) and IANA-Token based names do not have first class support at the moment. Feel free to submit an MR or extend one of the abstract classes within your project to support your usecase.

Wrote this in 2 days. Deserialization was rushed but is pretty solid overall.

ICalendar RFC: https://www.ietf.org/rfc/rfc2445.txt

---

# Usage

To use this plugin, add `icalendar` as a dependency in your pubspec.yaml file.

Most of the objects have built-in asserts that "assert" the RFC2445 spec. The idea is we don't break production code, we just throw out the stuff that doesn't make sense. There's a lot of different custom implementations of the ICalendar spec out there, if we threw an exception on every bad ICalendar object as we deserialized we wouldn't be able to deserialize anything. Maybe an opt-in "Strict Mode" flag could be on the cards in the future though.

## Deserialization

**Note:** Deserialization will add "no-op" default parameter values for free (where applicable) to better adhere to the RFC2445 spec. We won't modify any values, just assert what's already there.

```dart
import 'package:icalendar/icalendar.dart';

final testString = """
BEGIN:VCALENDAR
PRODID:-//xyz Corp//NONSGML PDA Calendar Version 1.0//EN
VERSION:2.0
BEGIN:VEVENT
DTSTAMP:19960704T120000Z
UID:uid1@example.com
ORGANIZER:mailto:jsmith@example.com
DTSTART:19960918T143000Z
DTEND:19960920T220000Z
STATUS:CONFIRMED
CATEGORIES:CONFERENCE
SUMMARY:Networld+Interop Conference
DESCRIPTION:Networld+Interop Conference and Exhibit\nAtlanta World Atlanta\, Georgia
END:VEVENT
END:VCALENDAR
""";

void main() {
    // Deserialize
    final calendars = ICalendar.fromICalendarString(testString);

    // Serialize
    for (var cal in calendars) {
        print("=====================");
        print(cal);
        print("=====================");
    }
}

```

## Serialization

```dart
import 'package:icalendar/icalendar.dart';

void main() {
  final ical = ICalendar(
    productIdentifier: ProductIdentifierProperty(
      "-//Powerbuilding//COACHAPP SCHED Calendar Version 1.0//EN",
    ),
    version: VersionProperty(), // Defaults to "2.0"
  );

  ical.addComponent(
    EventComponent(
      attendees: [
        AttendeeProperty(
          "btutovic@gmail.com",
          commonName: "Brian",
          rsvpExpectation: true,
          userType: CalendarUserType.individual,
        ),
      ],
      recurrenceRules: [
        RecurrenceRuleProperty(
          frequency: RecurrenceFrequency.daily,
          count: 2,
        ),
      ],
    ),
  );

  // Serialize to String
  final icalText = ical.toString();

  print(icalText);

  // Prints:
  // BEGIN:VCALENDAR
  // PRODID:-//Powerbuilding//COACHAPP SCHED Calendar Version 1.0//EN
  // VERSION:2.0
  // CALSCALE:GREGORIAN
  // BEGIN:VEVENT
  // ATTENDEE;CUTYPE=INDIVIDUAL;RSVP=TRUE;CN=Brian:MAILTO:btutovic@gmail.com
  // RRULE:FREQ=DAILY;COUNT=2;INTERVAL=1;WKST=MO
  // END:VEVENT
  // END:VCALENDAR
}
```

# TODO

- [ ] Components should have the same structure and only expose/accept native types. Then translate to ICalendar types when passing value to super.
- [ ] Write tests.......
- [ ] Implement Interoperability Support ([iTIP](https://datatracker.ietf.org/doc/html/rfc5546)):
  - Implement functions that make component modification more intuitive (modifyEvent, markCompleted on todo components, maybe a RRule builder, etc)
- [ ] Better documentation, maybe a script that reads the RFC2445 comment I left on most objects and grabs the relevant section of the spec.
- [ ] First-Class support for non-standard parameters/properties/components, and IANA-Token/Name objects

# Known Issues

- [ ] TimeZone Identifier support isn't great. Should be more intuitive.
- [ ] Floating DateTimes are almost always converted to UTC during deserialization

# Donations

You don't have to spend your money - I'd much rather a code contribution - but hey I'll take a coffee on the house.

<a href="https://www.buymeacoffee.com/btutovic" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/default-orange.png" alt="Buy Me A Coffee" height="41" width="174"></a>
