import 'package:icalendar/icalendar.dart';

const testString = """
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
DESCRIPTION:Networld+Interop Conference and Exhibit\n Atlanta World Atlanta, Georgia
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
