import 'package:bible_bloc/Feature/History/Views/HistoryIndex.dart';
import 'package:bible_bloc/Feature/InheritedBlocs.dart';
import 'package:bible_bloc/Feature/Navigation/navigation_feature.dart';
import 'package:bible_bloc/Foundation/foundation.dart';
import 'package:flutter/material.dart';
//import 'package:notus/notus.dart';

class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HistoryIndex(),
      bottomNavigationBar: BibleBottomNavigationBar(context: context),
    );
  }
}
