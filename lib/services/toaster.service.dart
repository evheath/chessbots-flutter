import 'dart:async';

import 'package:flutter/material.dart';

abstract class ToasterEvent {}

class ErrorEvent extends ToasterEvent {
  final String message;
  ErrorEvent(this.message);
}

class ToasterService {
  BuildContext context;
  ToasterService(this.context) {
    _eventController.stream.listen(_handleEvent);
  }

  StreamController<ToasterEvent> _eventController = StreamController();
  StreamSink<ToasterEvent> get event => _eventController.sink;

  void _handleEvent(ToasterEvent event) async {
    if (event is ErrorEvent) {
      _problemAlert(event.message);
    }
  }

  void _problemAlert(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Problem"),
            content: Text(message),
            actions: <Widget>[
              FlatButton(
                child: Text("Ah Shucks"),
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        });
  }

  @override
  void dispose() {
    _eventController.close();
  }
}
