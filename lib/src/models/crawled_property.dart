// Copyright (c) 2023 Brian Tutovic All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:equatable/equatable.dart';

import 'craweled_parameter.dart';

class CrawledProperty extends Equatable {
  final String name;
  final String value;
  final List<CrawledParameter> parameters;

  const CrawledProperty({
    required this.name,
    required this.value,
    required this.parameters,
  });

  @override
  List<Object?> get props => [];

  CrawledProperty copyWith({
    String? name,
    String? value,
    List<CrawledParameter>? parameters,
  }) =>
      CrawledProperty(
        name: name ?? this.name,
        value: value ?? this.value,
        parameters: parameters ?? this.parameters,
      );
}
