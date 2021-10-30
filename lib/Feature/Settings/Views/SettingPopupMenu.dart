
import '../../InheritedBlocs.dart';
import 'package:flutter/material.dart';

class SettingsPopupMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, bool>>(
      stream: InheritedBlocs.of(context).settingsBloc.settingsItems,
      initialData: Map<String, bool>(),
      builder:
          (BuildContext context, AsyncSnapshot<Map<String, bool>> snapshot) {
        return PopupMenuButton<String>(
          icon: Icon(Icons.more_vert),
          onSelected: (value) => this._selectItem(context, snapshot, value),
          itemBuilder: (context) => this._createPopupItems(context, snapshot),
        );
      },
    );
  }

  List<PopupMenuEntry> _createPopupItems(
      BuildContext context, AsyncSnapshot<Map<String, bool>> snapshot) {
    return snapshot.data.keys
        .map((key) => CheckedPopupMenuItem(
              checked: snapshot.data[key],
              child: Text(key),
              value: key,
            ))
        .toList();
  }

  _selectItem(BuildContext context, AsyncSnapshot<Map<String, bool>> snapshot,
      String value) {
    if (value == "Show Verse Numbers") {
      InheritedBlocs.of(context)
          .settingsBloc
          .shouldShowVerseNumbers
          .add(!snapshot.data[value]);
    } else if (value == "Immersive Reading Mode") {
      InheritedBlocs.of(context)
          .settingsBloc
          .shouldBeImmersiveReadingMode
          .add(!snapshot.data[value]);
    }
  }
}
