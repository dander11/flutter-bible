import 'package:bible_bloc/InheritedBlocs.dart';
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
    var items = List<PopupMenuEntry>();
    /* items.add(CheckedPopupMenuItem(
                checked: snapshot.data,
                child: Text("Show Verse Numbers"),
                value: 1,
              )); */
    return snapshot.data.keys
        .map((key) => CheckedPopupMenuItem(
              checked: snapshot.data[key],
              child: Text(key),
              value: key,
            ))
        .toList();
    /* CheckedPopupMenuItem(
                child: StreamBuilder<bool>(
                  stream: InheritedBlocs.of(context).settingsBloc.showVerseNumbers,
                  initialData: true,
                  builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                    if (snapshot.hasData) {
                      return CheckboxListTile(
                        value: snapshot.data,
                        onChanged: (bool value) {
                          InheritedBlocs.of(context)
                              .settingsBloc
                              .shouldShowVerseNumbers
                              .add(value);
                        },
                      );
                    } else {
                      return ListTile();
                    }
                  },
                ),
              ); */

    return items;
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
