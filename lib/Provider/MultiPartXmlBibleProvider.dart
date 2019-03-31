import 'package:bible_bloc/Models/Book.dart';
import 'package:bible_bloc/Models/Chapter.dart';
import 'package:bible_bloc/Models/ChapterElements/BeginParagraph.dart';
import 'package:bible_bloc/Models/ChapterElements/DivineName.dart';
import 'package:bible_bloc/Models/ChapterElements/EmptyElement.dart';
import 'package:bible_bloc/Models/ChapterElements/EndParagraph.dart';
import 'package:bible_bloc/Models/ChapterElements/Heading.dart';
import 'package:bible_bloc/Models/ChapterElements/IChapterElement.dart';
import 'package:bible_bloc/Models/ChapterElements/Subheading.dart';
import 'package:bible_bloc/Models/ChapterElements/Text.dart';
import 'package:bible_bloc/Models/ChapterElements/Verse.dart';
import 'package:bible_bloc/Models/ChapterElements/WordsOfChrist.dart';

import 'package:bible_bloc/Provider/IBibleProvider.dart';
import 'package:flutter/services.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:xml/xml.dart' as xml;

class MultiPartXmlBibleProvider extends IBibleProvider {
  xml.XmlDocument booksDirectory;
  GlobalConfiguration cfg;

  MultiPartXmlBibleProvider() {
    cfg = new GlobalConfiguration();
  }

  @override
  Future init() async {
    var path = (cfg.getString("multipartXmlBiblePath") + 'books.xml');
    booksDirectory = await loadDocument(path);
    return;
  }

  @override
  Future<List<Book>> getAllBooks() async {
    var xmlBooks = booksDirectory.findAllElements("book");
    var books = new List<Book>();
    for (var item in xmlBooks) {
      var book = _convertBookFromXml(item);
      books.add(book);
    }
    return books;
  }

  Book _convertBookFromXml(xml.XmlElement item) {
    var book = new Book(
      name: item.getAttribute("title"),
      chapters: _getChapters(item),
    );
    book.chapters.forEach((c) => c.book = book);
    return book;
  }

  List<Chapter> _getChapters(xml.XmlElement xmlBook) {
    var xmlChapters = xmlBook.findAllElements("chapter");
    List<Chapter> chapters = new List<Chapter>();
    for (var item in xmlChapters) {
      var chapter = new Chapter(number: int.parse(item.getAttribute("number")));
      chapters.add(chapter);
    }

    return chapters;
  }

  @override
  Book getBook(String name) {
    // TODO: implement getBook
    return null;
  }

  @override
  Future<Chapter> getChapter(String bookName, int chapterNumber) async {
    var path = (cfg.getString("multipartXmlBiblePath") +
        _getChapterPath(bookName, chapterNumber));
    xml.XmlDocument chapterDoc = await loadDocument(path);
    xml.XmlElement chapterElement = chapterDoc.findAllElements("book").first;
    Chapter convertChapterFromXml = _convertChapterFromXml(chapterElement);

    return convertChapterFromXml;
  }

  Chapter _convertChapterFromXml(xml.XmlElement item) {
    var chapter = new Chapter(number: int.parse(item.getAttribute("num")));
    List<IChapterElement> elements = _getChatperElements(item);
    //elements.removeWhere((e) => e is EmptyElement);
    chapter.elements = elements;
    return chapter;
  }

  List<IChapterElement> _flatten(List<IChapterElement> iterable) {
    return iterable
        .expand((IChapterElement e) =>
            e.elements != null && e.elements.length > 0
                ? _flatten(e.elements)
                : [e])
        .toList();
  }

  List<IChapterElement> _getChatperElements(xml.XmlElement node) {
    List<IChapterElement> elements = List<IChapterElement>();
    if (node.children.length == 0) {
      return elements;
    }
    for (var child in node.children) {
      if (child is xml.XmlText) {
        if (child.text.trim().isEmpty) {
          continue;
        }
      }
      var convertedElement = _convertXmlToChapterElement(child);
      if (child.children.length > 0 &&
          (convertedElement is Heading || convertedElement is EmptyElement)) {
        convertedElement.elements.addAll(_getChatperElements(child));
      }
      elements.add(convertedElement);
    }
    return elements;
  }

  IChapterElement _convertXmlToChapterElement(xml.XmlNode node) {
    var multipleSpaces = RegExp("[\n\t\r]*");
    if (node is xml.XmlElement) {
      var aNode = node as xml.XmlElement;
      if (aNode.name.local == "verse") {
        var verse = Verse(
          number: int.parse(node.getAttribute("num")),
          text: aNode.text.replaceAll(multipleSpaces, ""),
        );
        for (var item in node.children) {
          verse.elements.add(_convertXmlToChapterElement(item));
        }
        return verse;
      } else if (aNode.name.local == "heading") {
        var cleanedSpace = aNode.text.replaceAll(multipleSpaces, "");
        return Heading(text: cleanedSpace.trim());
      } else if (aNode.name.local == "woc") {
        var cleanedSpace = aNode.text.replaceAll(multipleSpaces, "");
        return WordsOfChrist(text: "\"${cleanedSpace.trim()}\"");
      } else if (aNode.name.local == "end-paragraph") {
        return EndParagraph();
      } else if (aNode.name.local == "begin-paragraph") {
        return BeginParagraph();
      } else if (aNode.name.local == "q") {
        switch (
            aNode.attributes.firstWhere((a) => a.name.local == "class").value) {
          case "begin-double":
            return ChaperText(text: " ${String.fromCharCode(8220)}");

            break;
          case "end-double":
            return ChaperText(text: "${String.fromCharCode(8221)}");

            break;
          case "begin-single":
            return ChaperText(text: " ${String.fromCharCode(8216)}");

            break;
          case "end-single":
            return ChaperText(text: "${String.fromCharCode(8217)}");

            break;
          default:
            return ChaperText(text: " ${String.fromCharCode(8220)}");
        }
      } else if (aNode.name.local == "subheading") {
        return Subheading(text: aNode.text.trim());
      } else if (aNode.name.local == "span" &&
          aNode.attributes.any((a) => a.value == "divine-name")) {
        return DivineName(text: " ${aNode.text.trim()}");
      } else {
        return EmptyElement();
      }
    } else if (node is xml.XmlText && node.text.trim().isNotEmpty) {
      // this is treating all text as chapter text
      //TODO fix this
      var spaceBeforePunctuation = RegExp(" [.!?\\-]");
      var punctuation = RegExp("[.!?\\-]");
      if (node.previousSibling != null &&
          node.previousSibling is xml.XmlElement &&
          (node.previousSibling.attributes
                  .any((a) => a.value == "begin-double") ||
              node.previousSibling.attributes
                  .any((a) => a.value == "end-double") ||
              node.previousSibling.attributes
                  .any((a) => a.value == "begin-single") ||
              node.previousSibling.attributes
                  .any((a) => a.value == "end-single"))) {
        return ChaperText(
            text: '''${node.text.replaceAll(multipleSpaces, "").trim()}''');
      } else if (node.text.contains(spaceBeforePunctuation)) {
        return ChaperText(
            text:
                ''' ${node.text.replaceAll(multipleSpaces, "").replaceAll(spaceBeforePunctuation, "").trim()}''');
      } else if (node.text.replaceAll(multipleSpaces, "").length == 1 &&
          node.text.contains(punctuation)) {
        return ChaperText(
            text: '''${node.text.replaceAll(multipleSpaces, "").trim()}''');
      } else {
        return ChaperText(
            text: ''' ${node.text.replaceAll(multipleSpaces, "").trim()}''');
      }
    } else {
      return EmptyElement();
    }
  }

  String _getChapterPath(String bookName, int chapterNumber) {
    var chapters = booksDirectory.findAllElements("chapter");
    xml.XmlElement chapterResourceName = null;
    if (bookName.contains(RegExp("[0-2]"))) {
      var number = bookName.split(" ")[0];
      var name = bookName.split(" ")[1];
      chapterResourceName = chapters.firstWhere((b) =>
          b.getAttribute("resourceName") ==
          "${name.toLowerCase()}_${number}_$chapterNumber");
    } else {
      chapterResourceName = chapters.firstWhere((b) =>
          b.getAttribute("resourceName") ==
          "${bookName.toLowerCase().replaceAll(" ", "_")}_$chapterNumber");
    }

    return chapterResourceName.getAttribute("resourceName") + ".xml";
  }

  @override
  Future<Chapter> getChapterById(int chapterId) {
    // TODO: implement getChapterById
    return null;
  }

  @override
  Future<List<Verse>> getSearchResults(
      String searchTerm, List<Book> booksToSearch) async {
    var chapters = booksToSearch.expand((book) => book.chapters);

    for (var chapter in chapters) {
      chapter = await this.getChapter(chapter.book.name, chapter.number);
    }
    Iterable<Verse> verses =
        chapters.expand((c) => c.elements.where((e) => e is Verse));
    verses = verses.where((verse) =>
        _contains(searchTerm.toLowerCase(), verse.text.toLowerCase()));
    if (verses.contains(" ") && !searchTerm.contains(" ")) {
      verses = verses
          .where((verse) => verse.text
              .toLowerCase()
              .replaceAll(".", "")
              .split(" ")
              .contains(searchTerm.toLowerCase()))
          .toList();
    } else {
      verses = verses.where((verse) =>
          verse.text.toLowerCase().contains(searchTerm.toLowerCase()));
    }
    return verses.toList();
  }

  static bool _contains(String query, String verse) {
    int i = 2; // First index to check.
    int length = verse.length;
    var C = query[query.length - 1];
    var B = query[query.length - 2];
    var A = query[query.length - 3];
    while (i < length) {
      if (verse[i] == C) {
        if (verse[i - 1] == B && verse[i - 2] == A) {
          return true;
        }
        // Must be at least 3 character away.
        i += 3;
        continue;
      } else if (verse[i] == B) {
        // Must be at least 1 characters away.
        i += 1;
        continue;
      } else if (verse[i] == A) {
        // Must be at least 2 characters away.
        i += 2;
        continue;
      } else {
        // Must be at least 4 characters away.
        i += 3;
        continue;
      }
    }

    // Nothing found.
    return false;
  }

  Future<xml.XmlDocument> loadDocument(String path) async {
    var fileData = await rootBundle.loadString(path, cache: false);
    return xml.parse(fileData);
  }
}
