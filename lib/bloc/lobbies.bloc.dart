import 'dart:async';
import 'package:chessbotsmobile/models/lobby.doc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import './base.bloc.dart';

class LobbiesBloc extends BlocBase {
  static final LobbiesBloc _singleton = LobbiesBloc._internal();

  factory LobbiesBloc() {
    return _singleton;
  }

  // dependencies
  final Firestore _db = Firestore.instance;

  /// external-in/internal-out controller

  /// external-in (alias)

  /// internal-in/external-out controller
  StreamController<List<LobbyDoc>> _lobbiesController =
      BehaviorSubject<List<LobbyDoc>>(seedValue: []);

  /// internal-in (alias)
  StreamSink<List<LobbyDoc>> get _internalInLobbies => _lobbiesController.sink;

  /// external-out (alias)
  Stream<List<LobbyDoc>> get lobbies$ => _lobbiesController.stream;

  // constructor
  LobbiesBloc._internal() {
    _db.collection('lobbies').snapshots().listen((qSnap) {
      List<LobbyDoc> _lobbies = qSnap.documents
          .where((snap) => snap["challengerBot"] == null)
          .map((snap) => LobbyDoc.fromSnapshot(snap))
          .toList();
      _internalInLobbies.add(_lobbies);
    });
  }
  void dispose() {
    _lobbiesController.close();
  }

  // public methods that the UI depends on
  Future<void> attemptToChallenge(LobbyDoc _lobby) async {
    // DocumentSnapshot _upToDateSnap = await _lobby.ref.get();
    // _upToDateSnap.data
    print("attempting to challenge ${_lobby.host}");
    return;
  }
}
