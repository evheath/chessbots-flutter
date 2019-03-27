import 'dart:async';
import 'package:rxdart/rxdart.dart';
import './base.bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class PrefsEvent {}

class ToggleDarkThemeEvent extends PrefsEvent {}

class PrefsState {
  final bool darkTheme;
  const PrefsState({this.darkTheme = false});
}

class PrefsBloc extends BlocBase {
  /// external-in/internal-out controller
  StreamController<PrefsEvent> _eventController = StreamController();

  /// external-in (alias)
  StreamSink<PrefsEvent> get event => _eventController.sink;

  /// internal-in/external-out controller
  StreamController<PrefsState> _prefsController =
      BehaviorSubject<PrefsState>(seedValue: PrefsState());

  /// internal-in (alias)
  StreamSink<PrefsState> get _internalInPrefs => _prefsController.sink;

  /// external-out (alias)
  Stream<PrefsState> get prefs$ => _prefsController.stream;

  // constructor
  PrefsBloc() {
    _buildAndSendPrefs();

    // listen for incoming events from the external-in sink
    _eventController.stream.listen(_handleEvent);
  }

  Future<void> _buildAndSendPrefs() async {
    final SharedPreferences _prefsInstance =
        await SharedPreferences.getInstance();

    final darkTheme = _prefsInstance.getBool('darkTheme') ?? false;

    PrefsState _state = PrefsState(darkTheme: darkTheme);
    _internalInPrefs.add(_state);
  }

  void _handleEvent(PrefsEvent event) async {
    final SharedPreferences _prefsInstance =
        await SharedPreferences.getInstance();

    if (event is ToggleDarkThemeEvent) {
      final darkTheme = _prefsInstance.getBool('darkTheme') ?? false;
      await _prefsInstance.setBool('darkTheme', !darkTheme);
    }

    await _buildAndSendPrefs();
  }

  void dispose() {
    _prefsController.close();
    _eventController.close();
  }
}
