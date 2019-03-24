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
  final _slideKey = GlobalKey();
  final SlidableController slidableController = new SlidableController();

  @override
  Widget build(BuildContext context) {
    var lastUpdated = widget.note.lastUpdated.toLocal();
    return Slidable.builder(
      key: _slideKey,
      controller: slidableController,
      delegate: new SlidableDrawerDelegate(),
      actionExtentRatio: 0.25,
      slideToDismissDelegate: new SlideToDismissDrawerDelegate(
        onWillDismiss: (actionType) {
          return showDialog<bool>(
            context: context,
            builder: (context) {
              return new AlertDialog(
                title: new Text('Delete'),
                content: new Text('Item will be deleted'),
                actions: <Widget>[
                  new FlatButton(
                    child: new Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                      //Slidable.of(context).close();
                    },
                  ),
                  new FlatButton(
                    child: new Text('Ok'),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
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
      secondaryActionDelegate: SlideActionBuilderDelegate(
          actionCount: 1,
          builder: (context, index, animation, mode) {
            return IconSlideAction(
              caption: 'Delete',
              color: Colors.redAccent.shade700,
              icon: Icons.delete,
              onTap: () => {},
            );
          }),
    );
  }
}
