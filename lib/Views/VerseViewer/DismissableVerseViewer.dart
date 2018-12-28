import 'package:bible_bloc/Models/Book.dart';
import 'package:bible_bloc/Models/Chapter.dart';
import 'package:bible_bloc/Views/VerseViewer/VerseText.dart';
import 'package:flutter/material.dart';

class Verses extends StatelessWidget {
  final Chapter chapter;
  final Book book;
  final Function(DismissDirection) swipeAction;
  final bool addBackgrounds;
  final bool showVerseNumbers;

  Verses({
    this.chapter,
    this.book,
    this.swipeAction,
    this.addBackgrounds,
    this.showVerseNumbers,
  });

  Widget build(BuildContext context) {
    List<TextSpan> chapterText = new List<TextSpan>();
    for (var verse in chapter.verses) {
      var number = new TextSpan(
        text: ' ' + verse.number.toString() + ' ',
        style: new TextStyle(fontWeight: FontWeight.bold),
      );
      var verText = new TextSpan(
        text: verse.text + ' ',
        style: new TextStyle(fontWeight: FontWeight.normal),
      );
      if (this.showVerseNumbers) {
        chapterText.add(number);
      }
      chapterText.add(verText);
    }
    return new Dismissible(
      secondaryBackground: this.getNextBook(context),
      background: this.getPrevBook(context),
      resizeDuration: null,
      onDismissed: (DismissDirection direction) => this.swipeAction(direction),
      child:
          new VerseText(book: book, chapter: chapter, chapterText: chapterText),
      key: new ValueKey(chapter.number),
    );
  }

  getPrevBook(context) {
    if (1 == chapter.number) {
      return new Column();
    } else {
      return new Verses(
        chapter: book.getChapter(chapter.number - 1),
        book: book,
        swipeAction: swipeAction,
        addBackgrounds: false,
        showVerseNumbers: this.showVerseNumbers,
      );
    }
  }

  getNextBook(context) {
    if (book.chapters.length == chapter.number) {
      return new Column(
        children: <Widget>[
          new Text(
            "End of " + book.name,
            style: Theme.of(context).textTheme.display1,
          )
        ],
      );
    } else {
      return new Verses(
        chapter: book.getChapter(chapter.number + 1),
        book: book,
        swipeAction: swipeAction,
        addBackgrounds: false,
        showVerseNumbers: this.showVerseNumbers,
      );
    }
  }
}
