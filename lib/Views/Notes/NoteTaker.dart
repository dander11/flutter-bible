import 'package:flutter/material.dart';
import 'package:zefyr/zefyr.dart';

class NotePage extends StatefulWidget {
  @override
  NotePageState createState() => NotePageState();
}

class NotePageState extends State<NotePage> {
  ZefyrController _controller;
  FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    // Create an empty document or load existing if you have one.
    // Here we create an empty document:
    final document = new NotusDocument();
    _controller = new ZefyrController(document);
    _focusNode = new FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    final theme = new ZefyrThemeData(
      textColor: Colors.white70,
      cursorColor: Colors.blue,
      toolbarTheme: ZefyrToolbarTheme.fallback(context).copyWith(
        color: Colors.grey.shade800,
        toggleColor: Colors.grey.shade900,
        iconColor: Colors.white,
        disabledIconColor: Colors.grey.shade500,
      ),
    );
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ZefyrScaffold(
          child: ZefyrTheme(
            data: theme,
            child: ZefyrEditor(
              controller: _controller,
              focusNode: _focusNode,
            ),
          ),
        ),
      ),
    );
  }
}
