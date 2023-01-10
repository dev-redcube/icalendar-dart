import 'package:equatable/equatable.dart';

import 'calendar_parameter.dart';
import 'calendar_parameter_value.dart';
import 'calendar_value.dart';

abstract class CalendarProperty<ValueType extends CalendarValue>
    extends Equatable {
  final String propertyName;
  final ValueType value;

  CalendarProperty(this.propertyName, this.value);

  List<CalendarParameter<CalendarParameterValue>> getParameters();

  @override
  String toString() {
    final res = StringBuffer();
    res.writeAll([
      propertyName.toUpperCase(),
      ...getParameters(),
      ...value.getInlineParameters()
    ], ";");
    res.write(":");
    res.write(value);
    return res.toString();
  }

  @override
  List<Object?> get props => [propertyName, value, getParameters()];
}
