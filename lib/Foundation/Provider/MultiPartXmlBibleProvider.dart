import 'package:flutter/services.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:xml/xml.dart' as xml;

import '../Models/Book.dart';
import '../Models/Chapter.dart';
import '../Models/ChapterElements/BeginParagraph.dart';
import '../Models/ChapterElements/CrossReferenceElement.dart';
import '../Models/ChapterElements/DivineName.dart';
import '../Models/ChapterElements/EmptyElement.dart';
import '../Models/ChapterElements/EndParagraph.dart';
import '../Models/ChapterElements/Heading.dart';
import '../Models/ChapterElements/IChapterElement.dart';
import '../Models/ChapterElements/Subheading.dart';
import '../Models/ChapterElements/Text.dart';
import '../Models/ChapterElements/Verse.dart';
import '../Models/ChapterElements/WordsOfChrist.dart';
import 'IBibleProvider.dart';

class MultiPartXmlBibleProvider extends IBibleProvider {
  xml.XmlDocument _booksDirectory;
  GlobalConfiguration _cfg;
  RegExp _multipleSpaces = RegExp("[\n\t\r]*");

  List<Book> _books;

  MultiPartXmlBibleProvider() {
    _cfg = GlobalConfiguration();
  }

  @override
  Future init() async {
    var path = (_cfg.getString("multipartXmlBiblePath") + 'books.xml');
    _booksDirectory = await loadDocument(path);
    return;
  }

  @override
  Future<List<Book>> getAllBooks() async {
    var xmlBooks = _booksDirectory.findAllElements("book");
    _books = List<Book>();
    for (var item in xmlBooks) {
      var book = _convertBookFromXml(item);
      _books.add(book);
    }
    return _books;
  }

  Book _convertBookFromXml(xml.XmlElement item) {
    var book = Book(
        name: item.getAttribute("title"),
        chapters: _getChapters(item),
        number: int.parse(item.getAttribute("number")));
    book.chapters?.forEach((c) => c.book = book);
    return book;
  }

  List<Chapter> _getChapters(xml.XmlElement xmlBook) {
    var xmlChapters = xmlBook.findAllElements("chapter");
    List<Chapter> chapters = List<Chapter>();

    for (var item in xmlChapters) {
      var chapter = Chapter(
        number: int.parse(item.getAttribute("number")),
        referenceName: (_cfg.getString("bibleReferencePath") +
            item.getAttribute("referenceName") +
            ".txt"),
      );
      chapters?.add(chapter);
    }

    return chapters;
  }

  @override
  Future<Chapter> getChapter(String bookName, int chapterNumber) async {
    var path = (_cfg.getString("multipartXmlBiblePath") +
        _getChapterPath(bookName, chapterNumber));
    var referencePath = (_cfg.getString("bibleReferencePath") +
        _getChapterReferencePath(bookName, chapterNumber));
    xml.XmlDocument chapterDoc = await loadDocument(path);
    xml.XmlElement chapterElement = chapterDoc.findAllElements("book").first;
    Chapter convertChapterFromXml = _convertChapterFromXml(chapterElement);

    convertChapterFromXml.book = _books
        .firstWhere((b) => b.name.toLowerCase() == bookName.toLowerCase());
    convertChapterFromXml.elements
        .forEach((e) => e.chapter = convertChapterFromXml);
    convertChapterFromXml.referenceName = referencePath;

    return convertChapterFromXml;
  }

  @override
  Future<Chapter> getChapterByBookNumber(
      int bookNumber, int chapterNumber) async {
    var bookName = _getBookNameByNumber(bookNumber);
    return this.getChapter(bookName, chapterNumber);
  }

  Chapter _convertChapterFromXml(xml.XmlElement item) {
    var chapterElement = item.findElements("chapter").first;
    var chapter =
        Chapter(number: int.parse(chapterElement.getAttribute("num")));
    List<IChapterElement> elements = _getChatperElements(item);
    //elements.removeWhere((e) => e is EmptyElement);

    chapter.elements = _flattenList(elements);
    return chapter;
  }

  List<IChapterElement> _flattenList(List<IChapterElement> iterable) {
    return iterable
        .expand((IChapterElement e) =>
            e.elements != null && e.elements.length > 0 && (e is EmptyElement)
                ? _flattenList(e.elements)
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
    if (node is xml.XmlElement) {
      return _convertNonTextElement(node);
    } else if (node is xml.XmlText && node.text.trim().isNotEmpty) {
      return _convertTextElement(node);
    } else {
      return EmptyElement();
    }
  }

  /* <crossref let="a" cid="c44001001.1">
                            </crossref> */
  IChapterElement _convertNonTextElement(xml.XmlElement node) {
    var aNode = node;
    if (aNode.name.local == "verse") {
      return _convertVerse(node, aNode);
    } else if (aNode.name.local == "heading") {
      var cleanedSpace = aNode.text.replaceAll(_multipleSpaces, "");
      var heading = Heading(text: cleanedSpace.trim());
      return heading;
    } else if (aNode.name.local == "woc") {
      var cleanedSpace = aNode.text.replaceAll(_multipleSpaces, "");
      return WordsOfChrist(text: "\"${cleanedSpace.trim()}\"");
    } else if (aNode.name.local == "end-paragraph") {
      return EndParagraph();
    } else if (aNode.name.local == "begin-paragraph") {
      return BeginParagraph();
    } else if (aNode.name.local == "q") {
      return _convertQuotationMark(aNode);
    } else if (aNode.name.local == "subheading") {
      return Subheading(text: aNode.text.trim());
    } else if (_isXmlElementADivineName(aNode)) {
      return DivineName(text: " ${aNode.text.trim()}");
    } else if (aNode.name.local == "crossref") {
      return CrossReferenceElement(
          letter: node.getAttribute("let"),
          referenceId: node.getAttribute("cid"));
    } else {
      return EmptyElement();
    }
  }

  bool _isXmlElementADivineName(xml.XmlElement aNode) {
    return aNode.name.local == "span" &&
        aNode.attributes.any((a) => a.value == "divine-name");
  }

  ChapterText _convertQuotationMark(xml.XmlElement aNode) {
    switch (aNode.attributes.firstWhere((a) => a.name.local == "class").value) {
      case "begin-double":
        return ChapterText(text: " ${String.fromCharCode(8220)}");

        break;
      case "end-double":
        return ChapterText(text: "${String.fromCharCode(8221)}");

        break;
      case "begin-single":
        return ChapterText(text: " ${String.fromCharCode(8216)}");

        break;
      case "end-single":
        return ChapterText(text: "${String.fromCharCode(8217)}");

        break;
      default:
        return ChapterText(text: " ${String.fromCharCode(8220)}");
    }
  }

  Verse _convertVerse(xml.XmlElement node, xml.XmlElement aNode) {
    var verse = Verse(
      number: int.parse(node.getAttribute("num")),
      text: aNode.text.replaceAll(_multipleSpaces, ""),
    );
    for (var item in node.children) {
      verse.elements.add(_convertXmlToChapterElement(item));
    }
    return verse;
  }

  ChapterText _convertTextElement(xml.XmlText node) {
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
      return ChapterText(
          text: '''${node.text.replaceAll(_multipleSpaces, "").trim()}''');
    } else if (node.text.contains(spaceBeforePunctuation)) {
      return ChapterText(
          text:
              ''' ${node.text.replaceAll(_multipleSpaces, "").replaceAll(spaceBeforePunctuation, "").trim()}''');
    } else if (node.text.replaceAll(_multipleSpaces, "").length == 1 &&
        node.text.contains(punctuation)) {
      return ChapterText(
          text: '''${node.text.replaceAll(_multipleSpaces, "").trim()}''');
    } else {
      return ChapterText(
          text: ''' ${node.text.replaceAll(_multipleSpaces, "").trim()}''');
    }
  }

  String _getChapterPath(String bookName, int chapterNumber) {
    var chapters = _booksDirectory.findAllElements("chapter");
    xml.XmlElement chapterResourceName;
    if (bookName.contains(RegExp("[0-3]"))) {
      var number = bookName.split(" ")[0];
      var name = bookName.split(" ")[1];
      chapterResourceName = chapters?.firstWhere((b) =>
          b.getAttribute("resourceName") ==
          "${name.toLowerCase()}_${number}_$chapterNumber");
    } else {
      chapterResourceName = chapters?.firstWhere((b) =>
          b.getAttribute("resourceName") ==
          "${bookName.toLowerCase().replaceAll(" ", "_")}_$chapterNumber");
    }

    return chapterResourceName.getAttribute("resourceName") + ".xml";
  }

  Future<xml.XmlDocument> loadDocument(String path) async {
    var fileData = await rootBundle.loadString(path, cache: false);
    return xml.parse(fileData);
  }

  String _getChapterReferencePath(String bookName, int chapterNumber) {
    var chapters = _booksDirectory.findAllElements("chapter");
    xml.XmlElement chapterResourceName;
    if (bookName.contains(RegExp("[0-3]"))) {
      var number = bookName.split(" ")[0];
      var name = bookName.split(" ")[1];
      chapterResourceName = chapters?.firstWhere((b) =>
          b.getAttribute("resourceName") ==
          "${name.toLowerCase()}_${number}_$chapterNumber");
    } else {
      chapterResourceName = chapters?.firstWhere((b) =>
          b.getAttribute("resourceName") ==
          "${bookName.toLowerCase().replaceAll(" ", "_")}_$chapterNumber");
    }

    return chapterResourceName.getAttribute("referenceName") + ".txt";
  }

  String _getBookNameByNumber(int bookNumber) {
    var books = _booksDirectory.findAllElements("book");
    var bookName = books
        .firstWhere((xml.XmlElement x) =>
            int.parse(x.getAttribute("number")) == bookNumber)
        .getAttribute("title");
    return bookName;
  }
}
