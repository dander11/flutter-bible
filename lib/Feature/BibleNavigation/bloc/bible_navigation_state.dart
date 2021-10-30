part of 'bible_navigation_bloc.dart';

@immutable
abstract class BibleNavigationState {}

class BibleNavigationInitial extends BibleNavigationState {}

class BibleNavigationLoaded extends BibleNavigationState {
  final List<Book> books;

  BibleNavigationLoaded(this.books);
}