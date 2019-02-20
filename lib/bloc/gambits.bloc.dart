import 'dart:async';
import 'package:rxdart/subjects.dart';

import 'package:flutter/material.dart';

import './base.bloc.dart';

class Gambit {
  IconData icon;
  Color color;
  String title;
  String description;

  Gambit({
    this.icon = Icons.pregnant_woman,
    this.color = Colors.black,
    this.title = "I was uninitalized",
    this.description = "Someone created me incorrectly :O",
  });
}

class GambitEvent {}

class ReorderEvent extends GambitEvent {
  int oldIndex;
  int newIndex;

  ReorderEvent(
    this.oldIndex,
    this.newIndex,
  );
}

class GambitsBloc implements BlocBase {
  // state
  List<Gambit> _gambits = [];

  // controllers
  StreamController<List<Gambit>> _gambitsController =
      BehaviorSubject<List<Gambit>>();
  StreamController<GambitEvent> _eventController = StreamController();

  // external in
  StreamSink<GambitEvent> get reorder => _eventController.sink;

  // internal out
  GambitsBloc() {
    //TODO implement how gambits get intially set
    _gambits = [
      Gambit(title: 'derp bloc'),
      Gambit(title: 'herp bloc'),
      Gambit(title: 'merp bloc')
    ];
    _eventController.stream.listen(_handleEvent);
  }
  void _handleEvent(GambitEvent event) {
    if (event is ReorderEvent) {
      int oldIndex = event.oldIndex;
      int newIndex = event.newIndex;
      if (oldIndex < newIndex) {
        // removing the item at oldIndex will shorten the list by 1.
        newIndex -= 1;
      }
      final Gambit movedGambit = _gambits.removeAt(oldIndex);
      _gambits.insert(newIndex, movedGambit);
    }
    _internalIn.add(_gambits);
  }

  // internal in
  StreamSink<List<Gambit>> get _internalIn => _gambitsController.sink;

  // external out
  Stream<List<Gambit>> get gambits => _gambitsController.stream;

  // tear down
  void dispose() {
    _eventController.close();
    _gambitsController.close();
  }
}
