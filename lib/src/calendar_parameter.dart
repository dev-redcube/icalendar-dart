import 'package:equatable/equatable.dart';

import 'calendar_parameter_value.dart';

abstract class CalendarParameter<ValueType extends CalendarParameterValue>
    extends Equatable {
  final String parameterName;
  final ValueType value;

  CalendarParameter(this.parameterName, this.value);

  @override
  String toString() {
    final res = StringBuffer();
    res.write(parameterName.toUpperCase());
    res.write("=");
    res.write(value);
    return res.toString();
  }

  @override
  List<Object?> get props => [parameterName, value];
}
