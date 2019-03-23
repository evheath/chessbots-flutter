import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class MatchDoc {
  /// A reference to this document in firestore
  /// Think of it as 'self' or 'this'
  /// Does not get serialized
  DocumentReference ref;

  /// user ID belonging to owner to the black bot
  String blackUID;
  DocumentReference blackBot;

  /// user ID belonging to owner to the white bot
  String whiteUID;
  DocumentReference whiteBot;
  String fen;

  MatchDoc.fromSnapshot(DocumentSnapshot _documentSnapshot) {
    this.ref = _documentSnapshot.reference;
    Map<String, dynamic> _snapshotData = _documentSnapshot.data;
    this.blackUID = _snapshotData["blackUID"];
    this.blackBot = _snapshotData["blackBot"];
    this.whiteUID = _snapshotData["whiteUID"];
    this.whiteBot = _snapshotData["whiteBot"];
    this.fen = _snapshotData["fen"] ??
        'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1';
  }

  Future<void> syncWithFirestore() async {
    return ref.updateData(_serialize());
  }

  Map<String, dynamic> _serialize() {
    Map<String, dynamic> _map = {
      "blackUID": blackUID,
      "blackBot": blackBot,
      "whiteUID": whiteUID,
      "whiteBot": whiteBot,
      "fen": fen,
    };
    return _map;
  }
}
