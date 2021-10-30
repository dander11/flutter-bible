import '../../Feature/History/Views/HistoryIndex.dart';
import '../../Feature/InheritedBlocs.dart';
import '../../Feature/Navigation/navigation_feature.dart';
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
