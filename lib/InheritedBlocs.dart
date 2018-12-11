import 'package:bible_bloc/Blocs/bible_bloc.dart';
import 'package:flutter/cupertino.dart';

class InheritedBlocs extends InheritedWidget {
  InheritedBlocs({Key key, this.bibleBloc, this.child})
      : super(key: key, child: child);

  final Widget child;
  final BibleBloc bibleBloc;

  static InheritedBlocs of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(InheritedBlocs)
        as InheritedBlocs);
  }

  @override
  bool updateShouldNotify(InheritedBlocs oldWidget) {
    return true;
  }
}
