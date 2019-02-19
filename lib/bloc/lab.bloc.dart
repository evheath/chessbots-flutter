import 'dart:async';
import 'package:rxdart/subjects.dart';

import './base.bloc.dart';

class LabBloc implements BlocBase {
  bool _whiteOnBottom;

  // out
  StreamController<bool> _whiteOnBottomController = BehaviorSubject<bool>();
  Stream<bool> get whiteOnBottom => _whiteOnBottomController.stream;

  // in
  StreamController _eventController = StreamController();
  StreamSink get flipBoard => _eventController.sink;

  // constructor
  LabBloc() {
    _whiteOnBottom = true;
    _eventController.stream.listen(_handleLogic);
  }

  void dispose() {
    _eventController.close();
    _whiteOnBottomController.close();
  }

  void _handleLogic(data) {
    _whiteOnBottom = !_whiteOnBottom;
    _whiteOnBottomController.sink.add(_whiteOnBottom);
  }
}
