import 'dart:async';

import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

class SettingsBloc {
  Sink<bool> get shouldShowVerseNumbers => _showVerseNumbersController.sink;
  final _showVerseNumbersController = StreamController<bool>();

  Stream<bool> get showVerseNumbers => _showVerseNumbers.stream;
  final _showVerseNumbers = BehaviorSubject<bool>();

  Sink<bool> get shouldBeImmersiveReadingMode =>
      _shouldBeImmersiveReadingModeController.sink;
  final _shouldBeImmersiveReadingModeController = StreamController<bool>();

  Stream<bool> get immersiveReadingMode => _immersiveReadingMode.stream;
  final _immersiveReadingMode = BehaviorSubject<bool>();

  Stream<Map<String, bool>> get settingsItems => _settingsItems.stream;
  final _settingsItems = BehaviorSubject<Map<String, bool>>();

  SettingsBloc() {
    var settings = Map<String, bool>();

    settings["Show Verse Numbers"] = true;
    settings["Immersive Reading Mode"] = false;
    shouldShowVerseNumbers.add(true);
    _showVerseNumbersController.stream.listen((bool shouldShow) async {
      _showVerseNumbers.add(shouldShow);
      settings["Show Verse Numbers"] = shouldShow;
      _settingsItems.add(settings);
    });

    _shouldBeImmersiveReadingModeController.stream
        .listen((bool shouldBeImmersive) async {
      _immersiveReadingMode.add(shouldBeImmersive);
      settings["Immersive Reading Mode"] = shouldBeImmersive;
      _settingsItems.add(settings);
      if (shouldBeImmersive) {
        SystemChrome.setEnabledSystemUIOverlays([]);
      } else {
        SystemChrome.setEnabledSystemUIOverlays(
            [SystemUiOverlay.bottom, SystemUiOverlay.top]);
      }
    });
    _settingsItems.add(settings);
  }

  dispose() {
    _showVerseNumbersController.close();
    _showVerseNumbers.close();
    _immersiveReadingMode.close();
    _shouldBeImmersiveReadingModeController.close();
  }
}
