// Copyright (c) 2023 Brian Tutovic All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:equatable/equatable.dart';

import 'calendar_property.dart';

abstract class CalendarComponent extends Equatable {
  final String componentName;

  const CalendarComponent(this.componentName);

  List<CalendarProperty> getProperties();

  List<CalendarComponent> getSubComponents() {
    return [];
  }

  @override
  String toString() {
    final res = StringBuffer();
    final props = getProperties();
    final subComponents = getSubComponents();
    res.writeln("BEGIN:${componentName.toUpperCase()}");
    res.writeAll(props, "\n");
    if (props.isNotEmpty) res.write("\n");
    res.writeAll(subComponents);
    res.writeln("END:${componentName.toUpperCase()}");
    return res.toString();
  }

  @override
  List<Object?> get props => [
        componentName,
        getProperties(),
        getSubComponents(),
      ];
}
