import 'dart:async';
import 'package:rxdart/subjects.dart';

import './base.bloc.dart';

class IncrementBloc implements BlocBase {
  int _counter;

  // counter
  // StreamController<int> _counterController = StreamController<int>.broadcast();
  StreamController<int> _counterController = BehaviorSubject<int>();
  StreamSink<int> get _inAdd => _counterController.sink;
  Stream<int> get outCounter => _counterController.stream;

  // actions
  StreamController _actionController = StreamController();
  StreamSink get incrementCounter => _actionController.sink;

  IncrementBloc() {
    _counter = 0;
    _actionController.stream.listen(_handleLogic);
  }

  void dispose() {
    print('increment bloc disposed HURKKK');
    _actionController.close();
    _counterController.close();
  }

  void _handleLogic(data) {
    _counter += 3;
    _inAdd.add(_counter);
  }
}
