// Copyright (c) 2023 Brian Tutovic All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// ignore_for_file: avoid_print

import '../calendar_component.dart';
import '../calendar_property.dart';
import '../calendar_value.dart';
import '../models/crawled_block.dart';
import '../parameters/value_data_type.dart';
import '../properties/action.dart';
import '../properties/attachment.dart';
import '../properties/attendee.dart';
import '../properties/categories.dart';
import '../properties/classification.dart';
import '../properties/comment.dart';
import '../properties/contact.dart';
import '../properties/date_time_created.dart';
import '../properties/date_time_end.dart';
import '../properties/date_time_stamp.dart';
import '../properties/date_time_start.dart';
import '../properties/description.dart';
import '../properties/duration.dart';
import '../properties/exception_date_times.dart';
import '../properties/exception_rule.dart';
import '../properties/geographic_position.dart';
import '../properties/last_modified.dart';
import '../properties/location.dart';
import '../properties/organizer.dart';
import '../properties/priority.dart';
import '../properties/recurrence_date_times.dart';
import '../properties/recurrence_id.dart';
import '../properties/recurrence_rule.dart';
import '../properties/related_to.dart';
import '../properties/request_status.dart';
import '../properties/resources.dart';
import '../properties/sequence.dart';
import '../properties/status.dart';
import '../properties/summary.dart';
import '../properties/time_transparency.dart';
import '../properties/unique_identifier.dart';
import '../properties/url.dart';
import 'alarm.dart';

/// RFC2445 Section 4.6.1
class EventComponent extends CalendarComponent {
  final ClassificationProperty? classification;
  final DateTimeCreatedProperty? dateTimeCreated;
  final DescriptionProperty? description;
  final DateTimeStartProperty? dateTimeStart;
  final GeographicPositionProperty? geographicPosition;
  final LastModifiedProperty? lastModified;
  final LocationProperty? location;
  final OrganizerProperty? organizer;
  final PriorityProperty? priority;
  final DateTimeStampProperty? dateTimeStamp;
  final SequenceProperty? sequence;
  final StatusProperty? status;
  final SummaryProperty? summary;
  final TimeTransparencyProperty? timeTransparency;
  final UniqueIdentifierProperty? uniqueIdentifier;
  final URLProperty? url;
  final RecurrenceIdProperty? recurrenceId;
  final DateTimeEndProperty? end;
  final DurationProperty? duration;
  final List<UriAttachmentProperty>? uriAttachments;
  final List<BinaryAttachmentProperty>? binaryAttachments;
  final List<AttendeeProperty>? attendees;
  final List<CategoriesProperty>? categories;
  final List<CommentProperty>? comments;
  final List<ContactProperty>? contacts;
  final List<ExceptionDateTimesProperty>? exceptionDateTimes;
  final List<ExceptionRuleProperty>? exceptionRules;
  final List<RequestStatusProperty>? requestStatuses;
  final List<RelatedToProperty>? relatedTo;
  final List<ResourcesProperty>? resources;
  final List<RecurrenceDateTimesProperty>? recurrenceDateTimes;
  final List<RecurrenceRuleProperty>? recurrenceRules;
  final List<AudioAlarmComponent>? audioAlarms;
  final List<DisplayAlarmComponent>? displayAlarms;
  final List<EmailAlarmComponent>? emailAlarms;
  final List<ProcedureAlarmComponent>? procedureAlarms;

  const EventComponent({
    this.classification,
    this.dateTimeCreated,
    this.description,
    this.dateTimeStart,
    this.geographicPosition,
    this.lastModified,
    this.location,
    this.organizer,
    this.priority,
    this.dateTimeStamp,
    this.sequence,
    this.status,
    this.summary,
    this.timeTransparency,
    this.uniqueIdentifier,
    this.url,
    this.recurrenceId,
    this.end,
    this.duration,
    this.uriAttachments,
    this.binaryAttachments,
    this.attendees,
    this.categories,
    this.comments,
    this.contacts,
    this.exceptionDateTimes,
    this.exceptionRules,
    this.requestStatuses,
    this.relatedTo,
    this.resources,
    this.recurrenceDateTimes,
    this.recurrenceRules,
    this.audioAlarms,
    this.displayAlarms,
    this.emailAlarms,
    this.procedureAlarms,
  })  : assert(
          end == null || duration == null,
          "end and duration cannot both be supplied",
        ),
        super("VEVENT");

  factory EventComponent.fromCrawledBlock(CrawledBlock block) {
    assert(
      block.blockName.toUpperCase() == "VEVENT",
      "Received invalid block: ${block.blockName}",
    );

    ClassificationProperty? classification;
    DateTimeCreatedProperty? dateTimeCreated;
    DescriptionProperty? description;
    DateTimeStartProperty? dateTimeStart;
    GeographicPositionProperty? geographicPosition;
    LastModifiedProperty? lastModified;
    LocationProperty? location;
    OrganizerProperty? organizer;
    PriorityProperty? priority;
    DateTimeStampProperty? dateTimeStamp;
    SequenceProperty? sequence;
    StatusProperty? status;
    SummaryProperty? summary;
    TimeTransparencyProperty? timeTransparency;
    UniqueIdentifierProperty? uniqueIdentifier;
    URLProperty? url;
    RecurrenceIdProperty? recurrenceId;
    DateTimeEndProperty? end;
    DurationProperty? duration;
    List<UriAttachmentProperty>? uriAttachments;
    List<BinaryAttachmentProperty>? binaryAttachments;
    List<AttendeeProperty>? attendees;
    List<CategoriesProperty>? categories;
    List<CommentProperty>? comments;
    List<ContactProperty>? contacts;
    List<ExceptionDateTimesProperty>? exceptionDateTimes;
    List<ExceptionRuleProperty>? exceptionRules;
    List<RequestStatusProperty>? requestStatuses;
    List<RelatedToProperty>? relatedTo;
    List<ResourcesProperty>? resources;
    List<RecurrenceDateTimesProperty>? recurrenceDateTimes;
    List<RecurrenceRuleProperty>? recurrenceRules;
    List<AudioAlarmComponent>? audioAlarms;
    List<DisplayAlarmComponent>? displayAlarms;
    List<EmailAlarmComponent>? emailAlarms;
    List<ProcedureAlarmComponent>? procedureAlarms;

    for (var e in block.properties) {
      switch (e.name.toUpperCase()) {
        case "CLASS":
          classification = ClassificationProperty.fromCrawledProperty(e);
          break;
        case "CREATED":
          dateTimeCreated = DateTimeCreatedProperty.fromCrawledProperty(e);
          break;
        case "DESCRIPTION":
          description = DescriptionProperty.fromCrawledProperty(e);
          break;
        case "DTSTART":
          dateTimeStart = DateTimeStartProperty.fromCrawledProperty(e);
          break;
        case "GEO":
          geographicPosition =
              GeographicPositionProperty.fromCrawledProperty(e);
          break;
        case "LAST-MODIFIED":
          lastModified = LastModifiedProperty.fromCrawledProperty(e);
          break;
        case "LOCATION":
          location = LocationProperty.fromCrawledProperty(e);
          break;
        case "ORGANIZER":
          organizer = OrganizerProperty.fromCrawledProperty(e);
          break;
        case "PRIORITY":
          priority = PriorityProperty.fromCrawledProperty(e);
          break;
        case "DTSTAMP":
          dateTimeStamp = DateTimeStampProperty.fromCrawledProperty(e);
          break;
        case "SEQUENCE":
          sequence = SequenceProperty.fromCrawledProperty(e);
          break;
        case "STATUS":
          status = StatusProperty.fromCrawledProperty(e);
          break;
        case "SUMMARY":
          summary = SummaryProperty.fromCrawledProperty(e);
          break;
        case "TRANSP":
          timeTransparency = TimeTransparencyProperty.fromCrawledProperty(e);
          break;
        case "UID":
          uniqueIdentifier = UniqueIdentifierProperty.fromCrawledProperty(e);
          break;
        case "URL":
          url = URLProperty.fromCrawledProperty(e);
          break;
        case "RECURRENCE-ID":
          recurrenceId = RecurrenceIdProperty.fromCrawledProperty(e);
          break;
        case "DTEND":
          end = DateTimeEndProperty.fromCrawledProperty(e);
          break;
        case "DURATION":
          duration = DurationProperty.fromCrawledProperty(e);
          break;
        case "ATTACH":
          {
            final isBinary = e.parameters.any(
              (element) =>
                  element.name.toUpperCase() == "VALUE" &&
                  ValueDataTypeParameter.fromCrawledParameter(element).type ==
                      ValueType.binary,
            );

            if (isBinary) {
              binaryAttachments ??= [];
              binaryAttachments
                  .add(BinaryAttachmentProperty.fromCrawledProperty(e));
            } else {
              uriAttachments ??= [];
              uriAttachments.add(UriAttachmentProperty.fromCrawledProperty(e));
            }
            break;
          }
        case "ATTENDEE":
          attendees ??= [];
          attendees.add(AttendeeProperty.fromCrawledProperty(e));
          break;
        case "CATEGORIES":
          categories ??= [];
          categories.add(CategoriesProperty.fromCrawledProperty(e));
          break;
        case "COMMENT":
          comments ??= [];
          comments.add(CommentProperty.fromCrawledProperty(e));
          break;
        case "CONTACT":
          contacts ??= [];
          contacts.add(ContactProperty.fromCrawledProperty(e));
          break;
        case "EXDATE":
          exceptionDateTimes ??= [];
          exceptionDateTimes
              .add(ExceptionDateTimesProperty.fromCrawledProperty(e));
          break;
        case "EXRULE":
          exceptionRules ??= [];
          exceptionRules.add(ExceptionRuleProperty.fromCrawledProperty(e));
          break;
        case "REQUEST-STATUS":
          requestStatuses ??= [];
          requestStatuses.add(RequestStatusProperty.fromCrawledProperty(e));
          break;
        case "RELATED-TO":
          relatedTo ??= [];
          relatedTo.add(RelatedToProperty.fromCrawledProperty(e));
          break;
        case "RESOURCES":
          resources ??= [];
          resources.add(ResourcesProperty.fromCrawledProperty(e));
          break;
        case "RDATE":
          recurrenceDateTimes ??= [];
          recurrenceDateTimes
              .add(RecurrenceDateTimesProperty.fromCrawledProperty(e));
          break;
        case "RRULE":
          recurrenceRules ??= [];
          recurrenceRules.add(RecurrenceRuleProperty.fromCrawledProperty(e));
          break;
        default:
          print("Unknown property encountered in EventComponent: ${e.name}");
      }
    }

    for (var e in block.nestedBlocks) {
      switch (e.blockName.toUpperCase()) {
        case "VALARM":
          {
            final action = ActionProperty.fromCrawledProperty(
              e.properties.firstWhere(
                  (element) => element.name.toUpperCase() == "ACTION"),
            );
            switch (action.type) {
              case ActionType.audio:
                audioAlarms ??= [];
                audioAlarms.add(AudioAlarmComponent.fromCrawledBlock(e));
                break;
              case ActionType.display:
                displayAlarms ??= [];
                displayAlarms.add(DisplayAlarmComponent.fromCrawledBlock(e));
                break;
              case ActionType.email:
                emailAlarms ??= [];
                emailAlarms.add(EmailAlarmComponent.fromCrawledBlock(e));
                break;
              case ActionType.procedure:
                procedureAlarms ??= [];
                procedureAlarms
                    .add(ProcedureAlarmComponent.fromCrawledBlock(e));
                break;
            }
            break;
          }
        default:
          print(
              "Unknown component encountered in EventComponent: ${e.blockName}");
      }
    }

    return EventComponent(
      classification: classification,
      dateTimeCreated: dateTimeCreated,
      description: description,
      dateTimeStart: dateTimeStart,
      geographicPosition: geographicPosition,
      lastModified: lastModified,
      location: location,
      organizer: organizer,
      priority: priority,
      dateTimeStamp: dateTimeStamp,
      sequence: sequence,
      status: status,
      summary: summary,
      timeTransparency: timeTransparency,
      uniqueIdentifier: uniqueIdentifier,
      url: url,
      recurrenceId: recurrenceId,
      end: end,
      duration: duration,
      uriAttachments: uriAttachments,
      binaryAttachments: binaryAttachments,
      attendees: attendees,
      categories: categories,
      comments: comments,
      contacts: contacts,
      exceptionDateTimes: exceptionDateTimes,
      exceptionRules: exceptionRules,
      requestStatuses: requestStatuses,
      relatedTo: relatedTo,
      resources: resources,
      recurrenceDateTimes: recurrenceDateTimes,
      recurrenceRules: recurrenceRules,
      audioAlarms: audioAlarms,
      displayAlarms: displayAlarms,
      emailAlarms: emailAlarms,
      procedureAlarms: procedureAlarms,
    );
  }

  @override
  List<CalendarProperty<CalendarValue>> getProperties() {
    return [
      ...(<CalendarProperty<CalendarValue>?>[
        classification,
        dateTimeCreated,
        description,
        dateTimeStart,
        geographicPosition,
        lastModified,
        location,
        organizer,
        priority,
        dateTimeStamp,
        sequence,
        status,
        summary,
        timeTransparency,
        uniqueIdentifier,
        url,
        recurrenceId,
        end,
        duration,
      ].where((element) => element != null).map((e) => e!).toList()),
      ...(<List<CalendarProperty<CalendarValue>>?>[
        uriAttachments,
        binaryAttachments,
        attendees,
        categories,
        comments,
        contacts,
        exceptionDateTimes,
        exceptionRules,
        requestStatuses,
        relatedTo,
        resources,
        recurrenceDateTimes,
        recurrenceRules,
      ]
          .where((element) => element != null)
          .map((e) => e!)
          .expand((element) => element)
          .toList())
    ];
  }

  @override
  List<CalendarComponent> getSubComponents() {
    return [
      ...(audioAlarms ?? []),
      ...(displayAlarms ?? []),
      ...(emailAlarms ?? []),
      ...(procedureAlarms ?? []),
    ];
  }

  EventComponent copyWith(
    ClassificationProperty? classification,
    DateTimeCreatedProperty? dateTimeCreated,
    DescriptionProperty? description,
    DateTimeStartProperty? dateTimeStart,
    GeographicPositionProperty? geographicPosition,
    LastModifiedProperty? lastModified,
    LocationProperty? location,
    OrganizerProperty? organizer,
    PriorityProperty? priority,
    DateTimeStampProperty? dateTimeStamp,
    SequenceProperty? sequence,
    StatusProperty? status,
    SummaryProperty? summary,
    TimeTransparencyProperty? timeTransparency,
    UniqueIdentifierProperty? uniqueIdentifier,
    URLProperty? url,
    RecurrenceIdProperty? recurrenceId,
    DateTimeEndProperty? end,
    DurationProperty? duration,
    List<UriAttachmentProperty>? uriAttachments,
    List<BinaryAttachmentProperty>? binaryAttachments,
    List<AttendeeProperty>? attendees,
    List<CategoriesProperty>? categories,
    List<CommentProperty>? comments,
    List<ContactProperty>? contacts,
    List<ExceptionDateTimesProperty>? exceptionDateTimes,
    List<ExceptionRuleProperty>? exceptionRules,
    List<RequestStatusProperty>? requestStatuses,
    List<RelatedToProperty>? relatedTo,
    List<ResourcesProperty>? resources,
    List<RecurrenceDateTimesProperty>? recurrenceDateTimes,
    List<RecurrenceRuleProperty>? recurrenceRules,
    List<AudioAlarmComponent>? audioAlarms,
    List<DisplayAlarmComponent>? displayAlarms,
    List<EmailAlarmComponent>? emailAlarms,
    List<ProcedureAlarmComponent>? procedureAlarms,
  ) =>
      EventComponent(
        classification: classification ?? this.classification,
        dateTimeCreated: dateTimeCreated ?? this.dateTimeCreated,
        description: description ?? this.description,
        dateTimeStart: dateTimeStart ?? this.dateTimeStart,
        geographicPosition: geographicPosition ?? this.geographicPosition,
        lastModified: lastModified ?? this.lastModified,
        location: location ?? this.location,
        organizer: organizer ?? this.organizer,
        priority: priority ?? this.priority,
        dateTimeStamp: dateTimeStamp ?? this.dateTimeStamp,
        sequence: sequence ?? this.sequence,
        status: status ?? this.status,
        summary: summary ?? this.summary,
        timeTransparency: timeTransparency ?? this.timeTransparency,
        uniqueIdentifier: uniqueIdentifier ?? this.uniqueIdentifier,
        url: url ?? this.url,
        recurrenceId: recurrenceId ?? this.recurrenceId,
        end: end ?? this.end,
        duration: duration ?? this.duration,
        uriAttachments: uriAttachments ?? this.uriAttachments,
        binaryAttachments: binaryAttachments ?? this.binaryAttachments,
        attendees: attendees ?? this.attendees,
        categories: categories ?? this.categories,
        comments: comments ?? this.comments,
        contacts: contacts ?? this.contacts,
        exceptionDateTimes: exceptionDateTimes ?? this.exceptionDateTimes,
        exceptionRules: exceptionRules ?? this.exceptionRules,
        requestStatuses: requestStatuses ?? this.requestStatuses,
        relatedTo: relatedTo ?? this.relatedTo,
        resources: resources ?? this.resources,
        recurrenceDateTimes: recurrenceDateTimes ?? this.recurrenceDateTimes,
        recurrenceRules: recurrenceRules ?? this.recurrenceRules,
        audioAlarms: audioAlarms ?? this.audioAlarms,
        displayAlarms: displayAlarms ?? this.displayAlarms,
        emailAlarms: emailAlarms ?? this.emailAlarms,
        procedureAlarms: procedureAlarms ?? this.procedureAlarms,
      );
}
