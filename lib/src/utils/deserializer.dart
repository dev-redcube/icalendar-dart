import '../models/craweled_parameter.dart';
import '../models/crawled_block.dart';
import '../models/crawled_property.dart';

List<CrawledBlock> crawlICalendarLines(List<String> lines) {
  final String lowercaseBlockBeginPrefix = "begin:";
  final String lowercaseBlockEndPrefix = "end:";

  int nestedBlockDepth = -1;
  List<CrawledBlock> blocks = [];

  for (String line in lines) {
    final normalizedLine = line.trim();

    if (normalizedLine.isEmpty) continue;

    if (normalizedLine.toLowerCase().startsWith(lowercaseBlockBeginPrefix)) {
      nestedBlockDepth += 1;
      final blockName =
          normalizedLine.substring(lowercaseBlockBeginPrefix.length);

      // initialize block
      if (nestedBlockDepth == 0) {
        final blockName =
            normalizedLine.substring(lowercaseBlockBeginPrefix.length);
        blocks.add(
          CrawledBlock(
            blockName: blockName,
            properties: [],
            nestedBlocks: [],
          ),
        );
      } else if (nestedBlockDepth > 0) {
        blocks[blocks.length - 1] = blocks.last.addBlockAtDepth(
          CrawledBlock(
            blockName: blockName,
            properties: [],
            nestedBlocks: [],
          ),
          nestedBlockDepth - 1,
        );
      }
      continue;
    } else if (normalizedLine
        .toLowerCase()
        .startsWith(lowercaseBlockEndPrefix)) {
      nestedBlockDepth -= 1;
      continue;
    }

    // parse property
    final propertyName =
        normalizedLine.substring(0, normalizedLine.indexOf(RegExp(r';|:')));

    int curIndex = propertyName.length;
    List<CrawledParameter> parameters = [];

    while (normalizedLine[curIndex] != ":") {
      final nameEndIndex = normalizedLine.indexOf("=", curIndex);
      final name = normalizedLine.substring(curIndex + 1, nameEndIndex);

      // handle quoted values
      if (normalizedLine[nameEndIndex + 1] == "\"") {
        final valueEndIndex = normalizedLine.indexOf("\"", nameEndIndex + 2);
        final value = normalizedLine.substring(nameEndIndex + 2, valueEndIndex);
        parameters.add(CrawledParameter(name, value.replaceAll("\"", "")));
        curIndex = valueEndIndex + 1;
        continue;
      }

      final valueEndIndex =
          normalizedLine.indexOf(RegExp(r';|:'), nameEndIndex + 1);
      final value = normalizedLine.substring(nameEndIndex + 1, valueEndIndex);
      parameters.add(CrawledParameter(name, value));
      curIndex = valueEndIndex;
    }

    blocks[blocks.length - 1] = blocks.last.addPropertyAtDepth(
      CrawledProperty(
        name: propertyName,
        value: normalizedLine.substring(curIndex + 1),
        parameters: parameters,
      ),
      nestedBlockDepth,
    );
  }

  return blocks;
}
