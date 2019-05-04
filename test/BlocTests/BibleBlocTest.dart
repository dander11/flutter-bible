import 'dart:async';

import 'package:bible_bloc/Blocs/bible_bloc.dart';
import 'package:bible_bloc/Models/Book.dart';
import 'package:bible_bloc/Models/Chapter.dart';
import 'package:bible_bloc/Models/ChapterElements/Text.dart';
import 'package:bible_bloc/Models/ChapterReference.dart';
import 'package:bible_bloc/Providers/IBibleProvider.dart';
import 'package:bible_bloc/Providers/ISearchProvider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockBibleProvider extends Mock implements IBibleProvider {}

class MockSearchProvider extends Mock implements ISearchProvider {}

void main() {
  group(
    '_ChapterUpdate',
    () {
      IBibleProvider bibleProvider = MockBibleProvider();
      ISearchProvider searchProvider = MockSearchProvider();
      BibleBloc bloc;

      Book genesis = Book(
        name: "Genesis",
        chapters: List<Chapter>(),
      );
      Book exodus = Book(
        name: "Exodus",
        chapters: List<Chapter>(),
      );
      Book revelation = Book(
        name: "Revelation",
        chapters: List<Chapter>(),
      );
      List<Chapter> chapters = <Chapter>[
        Chapter(
          book: genesis,
          number: 1,
          elements: [
            ChapterText(
              text: "Chapter 1",
            ),
          ],
        ),
        Chapter(
          book: genesis,
          number: 2,
          elements: [
            ChapterText(
              text: "Chapter 2",
            ),
          ],
        ),
        Chapter(
          book: genesis,
          number: 3,
          elements: [
            ChapterText(
              text: "Chapter 3",
            ),
          ],
        ),
        Chapter(
          book: genesis,
          number: 4,
          elements: [
            ChapterText(
              text: "Chapter 4",
            ),
          ],
        ),
        Chapter(
          book: exodus,
          number: 1,
          elements: [
            ChapterText(
              text: "Chapter 1",
            ),
          ],
        ),
        Chapter(
          book: exodus,
          number: 2,
          elements: [
            ChapterText(
              text: "Chapter 2",
            ),
          ],
        ),
        Chapter(
          book: exodus,
          number: 3,
          elements: [
            ChapterText(
              text: "Chapter 3",
            ),
          ],
        ),
        Chapter(
          book: exodus,
          number: 4,
          elements: [
            ChapterText(
              text: "Chapter 4",
            ),
          ],
        ),
        Chapter(
          book: revelation,
          number: 1,
          elements: [
            ChapterText(
              text: "Chapter 1",
            ),
          ],
        ),
        Chapter(
          book: revelation,
          number: 2,
          elements: [
            ChapterText(
              text: "Chapter 2",
            ),
          ],
        ),
      ];
      genesis.chapters
          .addAll(chapters.where((chap) => chap.book.name == "Genesis"));
      exodus.chapters
          .addAll(chapters.where((chap) => chap.book.name == "Exodus"));
      revelation.chapters
          .addAll(chapters.where((chap) => chap.book.name == "Revelation"));
      when(bibleProvider.init()).thenAnswer((_) => Future.value(true));
      when(bibleProvider.getChapter(any, any)).thenAnswer((_) => Future.value(
          chapters.firstWhere((book) =>
              book.book.name == _.positionalArguments[0] &&
              book.number == _.positionalArguments[1])));
      when(bibleProvider.getAllBooks())
          .thenAnswer((_) => Future.value([genesis, exodus, revelation]));

      setUp(() async {
        SharedPreferences.setMockInitialValues({});
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('david.anderson.bibleapp', null);
        bloc = BibleBloc(bibleProvider, searchProvider);
      });
      tearDown(() {
        bloc.dispose();
        bloc = null;
      });
      test(
        'the first chapter in the bible is returned when nothing is stored',
        () {
          var expectedResponse = ChapterReference(chapter: chapters[0]);

          expect(
            bloc.chapterReference,
            emits(
              expectedResponse,
            ),
          );
        },
      );
      test(
        'updating current chapter emits current chapter',
        () {
          scheduleMicrotask(() {
            bloc.currentChapterReference
                .add(ChapterReference(chapter: chapters[0]));
            bloc.currentChapterReference
                .add(ChapterReference(chapter: chapters[1]));
            bloc.currentChapterReference
                .add(ChapterReference(chapter: chapters[2]));
          });
          expect(
            bloc.chapterReference,
            emitsInOrder(
              [
                ChapterReference(chapter: chapters[0]),
                ChapterReference(chapter: chapters[1]),
                ChapterReference(chapter: chapters[2]),
              ],
            ),
          );
        },
      );
      test(
        'updating current chapter correctly changes the next chapter',
        () {
          scheduleMicrotask(() {
            bloc.currentChapterReference
                .add(ChapterReference(chapter: chapters[0]));
            bloc.currentChapterReference
                .add(ChapterReference(chapter: chapters[1]));
            bloc.currentChapterReference
                .add(ChapterReference(chapter: chapters[2]));
          });
          expect(
            bloc.nextChapter,
            emitsInOrder(
              [
                chapters[1],
                chapters[2],
                chapters[3],
              ],
            ),
          );

          //bloc.currentChapterReference.add(expectedResponse);
        },
      );

      test(
        'updating current chapter correctly changes the previous chapter',
        () {
          scheduleMicrotask(() {
            bloc.currentChapterReference
                .add(ChapterReference(chapter: chapters[0]));
            bloc.currentChapterReference
                .add(ChapterReference(chapter: chapters[1]));
            bloc.currentChapterReference
                .add(ChapterReference(chapter: chapters[2]));
          });
          expect(
            bloc.previousChapter,
            emitsInOrder(
              [
                chapters[9],
                chapters[0],
                chapters[1],
              ],
            ),
          );

          //bloc.currentChapterReference.add(expectedResponse);
        },
      );
      test(
        'updating current chapter to last chapter show first chapter of next book',
        () {
          scheduleMicrotask(() {
            bloc.currentChapterReference
                .add(ChapterReference(chapter: genesis.chapters[0]));
            bloc.currentChapterReference
                .add(ChapterReference(chapter: genesis.chapters[1]));
            bloc.currentChapterReference
                .add(ChapterReference(chapter: genesis.chapters.last));
          });
          expect(
            bloc.nextChapter,
            emitsInOrder(
              [
                chapters[1],
                chapters[2],
                exodus.chapters.first,
              ],
            ),
          );
        },
      );

      test(
        'updating current chapter to first chapter show last chapter of prev book',
        () {
          scheduleMicrotask(() {
            bloc.currentChapterReference
                .add(ChapterReference(chapter: exodus.chapters[1]));
            bloc.currentChapterReference
                .add(ChapterReference(chapter: exodus.chapters[0]));
          });
          expect(
            bloc.previousChapter,
            emitsInOrder(
              [
                exodus.chapters[0],
                genesis.chapters.last,
              ],
            ),
          );
        },
      );
    },
  );
}
