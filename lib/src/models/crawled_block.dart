// Copyright (c) 2023 Brian Tutovic All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:equatable/equatable.dart';
import 'package:icalendar/icalendar.dart';

import 'crawled_property.dart';

class CrawledBlock extends Equatable {
  final String blockName;
  final List<CrawledProperty> properties;
  final List<CrawledBlock> nestedBlocks;

  const CrawledBlock({
    required this.blockName,
    required this.properties,
    required this.nestedBlocks,
  });

  CrawledBlock copyWith({
    String? blockName,
    List<CrawledProperty>? properties,
    List<CrawledBlock>? nestedBlocks,
  }) =>
      CrawledBlock(
        blockName: blockName ?? this.blockName,
        properties: properties ?? this.properties,
        nestedBlocks: nestedBlocks ?? this.nestedBlocks,
      );

  CrawledBlock addPropertyAtDepth(CrawledProperty property, int depth) {
    assert(depth >= 0);
    assert(depth == 0 || nestedBlocks.isNotEmpty);
    if (depth == 0) {
      return copyWith(
        properties: [...properties, property],
      );
    }
    return copyWith(
      nestedBlocks: [
        ...(nestedBlocks.length > 1
            ? nestedBlocks.sublist(0, nestedBlocks.length - 1)
            : []),
        nestedBlocks.last.addPropertyAtDepth(property, depth - 1),
      ],
    );
  }

  CrawledBlock replaceLastPropertyAtDepth(CrawledProperty property, int depth) {
    assert(depth >= 0);
    assert(depth == 0 || nestedBlocks.isNotEmpty);
    if (depth == 0) {
      return copyWith(
        properties: [...properties.sublist(0, properties.length - 1), property],
      );
    }
    return copyWith(
      nestedBlocks: [
        ...(nestedBlocks.length > 1
            ? nestedBlocks.sublist(0, nestedBlocks.length - 1)
            : []),
        nestedBlocks.last.replaceLastPropertyAtDepth(property, depth - 1),
      ],
    );
  }

  CrawledProperty getLastPropertyAtDepth(int depth) {
    assert(depth >= 0);
    assert(depth == 0 || nestedBlocks.isNotEmpty);
    if (depth == 0) {
      return properties.last;
    }
    return nestedBlocks.last.getLastPropertyAtDepth(depth - 1);
  }

  CrawledBlock addBlockAtDepth(CrawledBlock block, int depth) {
    assert(depth >= 0);
    assert(depth == 0 || nestedBlocks.isNotEmpty);
    if (depth == 0) {
      return copyWith(
        nestedBlocks: [...nestedBlocks, block],
      );
    }
    return copyWith(
      nestedBlocks: [
        ...(nestedBlocks.length > 1
            ? nestedBlocks.sublist(0, nestedBlocks.length - 1)
            : []),
        nestedBlocks.last.addBlockAtDepth(block, depth - 1),
      ],
    );
  }

  @override
  List<Object?> get props => [blockName, properties, nestedBlocks];
}
