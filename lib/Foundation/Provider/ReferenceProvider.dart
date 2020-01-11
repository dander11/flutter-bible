import 'package:bible_bloc/Foundation/Models/ChapterReference.dart';
import 'package:bible_bloc/Foundation/Provider/IReferenceProvider.dart';
import 'package:flutter/services.dart';
import 'package:global_configuration/global_configuration.dart';

class ReferenceProvider implements IReferenceProvider {
  GlobalConfiguration _cfg;

  ReferenceProvider() {
    _cfg = GlobalConfiguration();
  }

  Future<ChapterReference> getReferenceFromId(
      String referencePath, String referenceId) async {
    var bookNumber = referenceId.substring(1, 3);
    var chapterNumber = referenceId.substring(3, 6);
    var verseNumber = referenceId.substring(6, 9);
    var referenceNumber = referenceId.split(".")[1];
    var path = (referencePath);

    var fileData = await rootBundle.loadString(path, cache: false);
    var fileLines = fileData.split("\r\n");
    fileLines.forEach((f) => f.trim());
    var referenceLine = fileLines.firstWhere((line) =>
        line.startsWith("i") && line.split(" ")[1].contains(referenceId));
    var nextReferenceStartLine = fileLines.firstWhere((line) =>
        fileLines.indexOf(line) > fileLines.indexOf(referenceLine) &&
        line.startsWith("c"));
    var referenceLines = fileLines
        .getRange(fileLines.indexOf(referenceLine),
            fileLines.indexOf(nextReferenceStartLine))
        .toList();

    var userLines = "";
    for (var line in referenceLines) {
      if (line.startsWith("i")) {
      } else if (line.startsWith("m")) {
        var text = line.split("m ")[1];
        userLines += text;
      } else if (line.startsWith("r")) {
        var referenceIdOnLine = line.split(" ")[1];
        var lineText = line.split(referenceIdOnLine)[1];
        userLines += lineText;
      } else if (line.startsWith("V")) {}
    }

    print(userLines);
    //print(referenceLines.join(" "));
  }

  Future init() {}
}
