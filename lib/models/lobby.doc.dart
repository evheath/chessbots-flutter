import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class LobbyDoc {
  /// A reference to this document in firestore
  /// Think of it as 'self' or 'this'
  /// Does not get serialized
  DocumentReference ref;
  Timestamp createdAt;

  /// name of the bot hosting, consider changing
  String host;
  DocumentReference hostBot;
  bool hostReady;

  String challenger;
  DocumentReference challengerBot;

  String get minutesAgo {
    int _time = DateTime.now().difference(createdAt.toDate()).inMinutes;
    // String _plural = _time > 1 ? 's' : '';
    return "$_time\m ago";
  }

  LobbyDoc.fromSnapshot(DocumentSnapshot _documentSnapshot) {
    this.ref = _documentSnapshot.reference;
    Map<String, dynamic> _snapshotData = _documentSnapshot.data;
    this.createdAt = _snapshotData["createdAt"];
    this.host = _snapshotData["host"];
    this.hostBot = _snapshotData["hostBot"];
    this.challenger = _snapshotData["challenger"];
    this.challengerBot = _snapshotData["challengerBot"];
    this.hostReady = _snapshotData["hostReady"] ?? false;
  }

  Future<void> syncWithFirestore() async {
    return ref.updateData(_serialize());
  }

  Map<String, dynamic> _serialize() {
    Map<String, dynamic> _map = {
      "createdAt": createdAt,
      "host": host,
      "hostBot": hostBot,
      "challenger": challenger,
      "challengerBot": challengerBot,
      "hostReady": hostReady,
    };
    return _map;
  }
}
