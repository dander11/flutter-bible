import 'dart:io';

import 'package:bible_bloc/Models/Book.dart';
import 'package:bible_bloc/Models/Chapter.dart';
import 'package:bible_bloc/Models/Verse.dart';
import 'package:bible_bloc/Provider/IBibleProvider.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqlLiteBibleProvider extends IBibleProvider {
  Database _database;

  List<Map<String, dynamic>> _verses;

  List<Map<String, dynamic>> _chapters;
  Stopwatch watch = new Stopwatch();

  Future<Database> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();

    return _database;
  }

  initDB() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "BibleDb.db");

    Database db;
    try {
      db = await openDatabase(path, readOnly: true);
    } catch (e) {
      print("Error $e");
    }

    if (db == null) {
      print("Creating new copy from asset");

      ByteData data = await rootBundle.load(join("resources", "BibleDb.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await new File(path).writeAsBytes(bytes);

      db = await openDatabase(path, readOnly: true);
    } else {
      print("Opening existing database");
    }
    return db;
  }

  @override
  Future<List<Book>> getAllBooks() async {
    watch.start();
    var data = await this.database;
    var result = await data.query("Book");

    this._chapters = await data.query("Chapter");
    List<Book> books = List<Book>();
    for (var item in result) {
      var book = Book.fromJson(item);
      book.chapters = await _getChaptersForBook(book);
      books.add(book);
    }
    watch.stop();
    print("Getting all books took: ${watch.elapsedMilliseconds}ms");
    return books;
  }

  @override
  Book getBook(String name) {
    // TODO: implement getBook
    return null;
  }

  @override
  Chapter getChapter(String bookName, int chapterNumber) {
    // TODO: implement getChapter
    return null;
  }

  @override
  List<Verse> getSearchResults(String searchTerm, List<Book> booksToSearch) {
    // TODO: implement getSearchResults
    return null;
  }

  Future<List<Chapter>> _getChaptersForBook(Book book) async {
    var data = await this.database;
    /* var result =
         await data.query("Chapter", where: 'BookId = ?', whereArgs: [book.id]);*/
    var result = this._chapters.where((v) => v['BookId'] == book.id);

    List<Chapter> chapters = List<Chapter>();
    String query =
        "SELECT * FROM Verse WHERE Verse.ChapterId IN (SELECT Chapter.Id FROM Chapter where Chapter.BookId = ${book.id})";
    this._verses = await data.rawQuery(query);
    for (var item in result) {
      var chapter = Chapter.fromJson(item);
      chapter.book = book;
      chapter.verses = await _getVerses(chapter);
      chapters.add(chapter);
    }
    return chapters;
  }

  Future<List<Verse>> _getVerses(Chapter chapter) async {
    /* var data = await this.database;
    var result = await data
        .query("Verse", where: 'ChapterId = ?', whereArgs: [chapter.id]); */

    var result = this._verses.where((v) => v['ChapterId'] == chapter.id);
    List<Verse> verses = List<Verse>();
    for (var item in result) {
      var verse = Verse.fromJson(item);
      verse.chapter = chapter;
      verses.add(verse);
    }
    return verses;
  }
}
