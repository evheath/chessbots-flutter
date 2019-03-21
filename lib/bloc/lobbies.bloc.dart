import 'dart:async';
import 'package:chessbotsmobile/bloc/firestore.bloc.dart';
import 'package:chessbotsmobile/models/lobby.doc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  Future<DocumentReference> attemptCreateLobby(
      DocumentReference _bofRef) async {
    List<LobbyDoc> _currentLobbies = await lobbies$.first;
    FirebaseUser fbUser = await FirestoreBloc().user.first;

    // checking if player already has a lobby, otherwise we create a new one
    LobbyDoc _oldLobby = _currentLobbies
        .firstWhere((_lobby) => _lobby.uid == fbUser.uid, orElse: () => null);
    DocumentReference lobbyRef = _oldLobby != null
        ? _oldLobby.ref
        : Firestore.instance.collection('lobbies').document();

    var snap = await _bofRef.get();
    String nameofBot = snap['name'];

    await lobbyRef.setData({
      "host": nameofBot,
      "hostBot": _bofRef,
      "uid": fbUser.uid,
    });

    return lobbyRef;
  }

  Future<void> attemptToChallenge(
      LobbyDoc _lobby, DocumentReference bofRef) async {
    // re-fetch to document in case it is out of date
    DocumentSnapshot _upToDateSnap = await _lobby.ref.get();
    LobbyDoc _upToDateLobby = LobbyDoc.fromSnapshot(_upToDateSnap);
    if (_upToDateLobby.challengerBot != null) {
      throw ("Lobby already has a challenger");
    }
    FirebaseUser playerfbUser = await FirestoreBloc().user.first;
    if (_upToDateLobby.uid == playerfbUser.uid) {
      // this is the player's lobby so we aren't the challenger (rare circumstance)
      // we are replacing the host bot in case the player went back and selected a new one
      var botSnap = await bofRef.get();
      _upToDateLobby.host = botSnap['name'];
      _upToDateLobby.hostBot = bofRef;
    } else {
      _upToDateLobby.challengerBot = bofRef;
    }
    await _upToDateLobby.syncWithFirestore();
  }
}
