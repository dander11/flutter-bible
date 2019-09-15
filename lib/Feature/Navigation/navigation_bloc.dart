import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'AppPages.dart';

class NavigationBloc {
  Sink<AppPage> get nextPage => _nextPageController.sink;
  final _nextPageController = StreamController<AppPage>();

  Stream<AppPage> get currentPage => _currentPage.stream;
  final _currentPage = BehaviorSubject<AppPage>.seeded(AppPage.readerPage);

  NavigationBloc() {
    _nextPageController.stream.listen(
      (page) {
        updatePage(page);
      },
    );
  }

  updatePage(AppPage page) {
    currentPage.first.then((lastPage) {
      if (lastPage != page) {
        _currentPage.add(page);
      }
    });
  }

  dispose() {
    _nextPageController.close();
    _currentPage.close();
  }
}
