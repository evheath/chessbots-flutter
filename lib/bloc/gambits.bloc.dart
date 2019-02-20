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

class ReorderGambits extends GambitEvent {}

class GambitsBloc implements BlocBase {
  // state
  List<Gambit> _gambits;

  // controllers
  StreamController<List<Gambit>> _gambitsController =
      BehaviorSubject<List<Gambit>>();
  StreamController _eventController = StreamController();

  // external in
  StreamSink get incrementCounter => _eventController.sink;

  // internal out
  GambitsBloc() {
    //TODO implement how gambits get intially set
    _gambits = [
      Gambit(title: 'derp'),
      Gambit(title: 'herp'),
      Gambit(title: 'merp')
    ];
    _eventController.stream.listen(_handleEvent);
  }
  void _handleEvent(GambitEvent data) {
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
