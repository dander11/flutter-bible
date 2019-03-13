import 'package:bible_bloc/Blocs/notes_bloc.dart';
import 'package:bible_bloc/Views/Notes/NoteTaker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class NoteTile extends StatefulWidget {
  const NoteTile({
    Key key,
    @required this.note,
  }) : super(key: key);

  final Note note;

  @override
  _NoteTileState createState() => _NoteTileState();
}

class _NoteTileState extends State<NoteTile> {
  var _selected = false;

  @override
  Widget build(BuildContext context) {
    var lastUpdated = widget.note.lastUpdated.toLocal();
    new Slidable(
      delegate: new SlidableDrawerDelegate(),
      actionExtentRatio: 0.25,
      child: ListTile(
        selected: _selected,
        onLongPress: () {
          setState(() {
            _selected = !_selected;
          });
        },
        onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return NotePage(
                    note: widget.note,
                  );
                },
              ),
            ),
        title: Text(widget.note.title),
        subtitle:
            Text("${lastUpdated.month}/${lastUpdated.day}/${lastUpdated.year}"),
      ),
      secondaryActions: <Widget>[
        new IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => {},
        ),
      ],
    );
  }
}
