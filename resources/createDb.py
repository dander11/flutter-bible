import xml.etree.ElementTree as ET
import sqlite3


class Verse(object):
    text = ""
    number = 0

    def __init__(self, text, number):
        self.text = text
        self.number = number


def make_verse(text, number):
    verse = Verse(text, number)
    return verse


class Chapter(object):
    number = 0
    verses = []

    def __init__(self, verses, number):
        self.verses = verses
        self.number = number


def make_chapter(verses, number):
    chapter = Chapter(verses, number)
    return chapter


class Book(object):
    name = ""
    chapters = []

    def __init__(self, name, chapters):
        self.name = name
        self.chapters = chapters


def make_book(name, chapters):
    book = Book(name, chapters)
    return book


filepath = 'C:/Dev/flutter/apps/bible_bloc/resources/esv-updated.xml'

tree = ET.parse(filepath)
root = tree.getroot()
books = root.findall('book')
allBooks = []
for book in books:
    bookChapters = []
    for chapter in book.findall('chapter'):
        chapterVerses = []
        for verse in chapter.findall('verse'):
            aVerse = make_verse(verse.text, verse.get('number'))
            chapterVerses.append(aVerse)
        aChapter = make_chapter(chapterVerses, chapter.get('number'))
        bookChapters.append(aChapter)
    aBook = make_book(book.get('name'), bookChapters)
    allBooks.append(aBook)
print(allBooks.count)

conn = sqlite3.connect('./resources/BibleDb.db')
cursor = conn.cursor()
res = conn.execute("SELECT name FROM sqlite_master WHERE type='table';")
for name in res:
    print(name[0])
i = 0
for book in allBooks:
    cursor.execute(f"INSERT INTO Book VALUES('{book.name}','{i}')")
    i = i + 1
    bookId = cursor.lastrowid
    for chapter in book.chapters:
        cursor.execute(
            f"INSERT INTO Chapter (Number, BookId) VALUES('{chapter.number}','{bookId}')")
        chapterId = cursor.lastrowid
        for verse in chapter.verses:
            text = verse.text.replace("'", "''")
            cursor.execute(
                f"INSERT INTO Verse (Number, Text, ChapterId) VALUES('{verse.number}','{text}', '{chapterId}')")
conn.commit()
conn.close()
