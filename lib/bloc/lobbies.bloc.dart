import 'dart:async';
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
    //TODO checking for a lobby we already created

    DocumentReference newLobbyRef =
        Firestore.instance.collection('lobbies').document();

    var snap = await _bofRef.get();
    //TODO perhaps dump this, mostly used for UI quick checking
    String nameofBot = snap['name'];

    FirebaseUser fbUser = await FirebaseAuth.instance.currentUser();

    await newLobbyRef.setData({
      "host": nameofBot,
      "hostBot": _bofRef,
      "uid": fbUser.uid,
    });

    return newLobbyRef;
  }

  Future<void> attemptToChallenge(
      LobbyDoc _lobby, DocumentReference bofRef) async {
    // re-fetch to document in case it is out of date
    DocumentSnapshot _upToDateSnap = await _lobby.ref.get();
    LobbyDoc _upToDateLobby = LobbyDoc.fromSnapshot(_upToDateSnap);
    if (_upToDateLobby.challenger != null ||
        _upToDateLobby.challengerBot != null) {
      throw ("Lobby already has a challenger");
    }
    _upToDateLobby.challengerBot = bofRef;
    _upToDateLobby.challenger = "DERPname";
    await _upToDateLobby.syncWithFirestore();
  }
}
