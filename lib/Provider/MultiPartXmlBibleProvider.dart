import 'package:bible_bloc/Models/Book.dart';
import 'package:bible_bloc/Models/Chapter.dart';
import 'package:bible_bloc/Models/ChapterElements/BeginParagraph.dart';
import 'package:bible_bloc/Models/ChapterElements/EmptyElement.dart';
import 'package:bible_bloc/Models/ChapterElements/EndParagraph.dart';
import 'package:bible_bloc/Models/ChapterElements/Heading.dart';
import 'package:bible_bloc/Models/ChapterElements/IChapterElement.dart';
import 'package:bible_bloc/Models/ChapterElements/Subheading.dart';
import 'package:bible_bloc/Models/ChapterElements/Text.dart';
import 'package:bible_bloc/Models/ChapterElements/Verse.dart';

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
    if (node is xml.XmlElement) {
      var aNode = node as xml.XmlElement;
      if (aNode.name.local == "verse") {
        var verse = Verse(
          number: int.parse(node.getAttribute("num")),
        );
        for (var item in node.children) {
          verse.elements.add(_convertXmlToChapterElement(item));
        }
        return verse;
      } else if (aNode.name.local == "heading") {
        return Heading(text: aNode.text.trim());
      } else if (aNode.name.local == "end-paragraph") {
        return EndParagraph();
      } else if (aNode.name.local == "begin-paragraph") {
        return BeginParagraph();
      } else if (aNode.name.local == "q") {
        if (aNode.attributes.any((a) => a.value.contains("double"))) {
          return ChaperText(text: "\"");
        } else if (aNode.attributes.any((a) => a.value.contains("single"))) {
          return ChaperText(text: "\'");
        }
      } else if (aNode.name.local == "subheading") {
        return Subheading(text: aNode.text.trim());
      } else {
        return EmptyElement();
      }
    } else if (node is xml.XmlText && node.text.trim().isNotEmpty) {
      // this is treating all text as chapter text
      //TODO fix this
      return ChaperText(text: '''${node.text.trim()}''');
    } else {
      return EmptyElement();
    }
  }

  String _getChapterPath(String bookName, int chapterNumber) {
    var chapters = booksDirectory.findAllElements("chapter");
    var chapterResourceName = chapters.firstWhere((b) =>
        b.getAttribute("resourceName") ==
        "${bookName.toLowerCase()}_$chapterNumber");
    return chapterResourceName.getAttribute("resourceName") + ".xml";
  }

  @override
  Future<Chapter> getChapterById(int chapterId) {
    // TODO: implement getChapterById
    return null;
  }

  @override
  List<Verse> getSearchResults(String searchTerm, List<Book> booksToSearch) {
    // TODO: implement getSearchResults
    return null;
  }

  Future<xml.XmlDocument> loadDocument(String path) async {
    var fileData = await rootBundle.loadString(path, cache: false);
    return xml.parse(fileData);
  }
}
