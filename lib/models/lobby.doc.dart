import 'package:cloud_firestore/cloud_firestore.dart';

class LobbyDoc {
  // DateTime createdAt;
  String host;
  DocumentReference hostBot;
  bool hostReady;

  String challenger;
  DocumentReference challengerBot;

  LobbyDoc.fromFirestore(Map<String, dynamic> _snapshotData) {
    this.host = _snapshotData["host"];
    this.hostBot = _snapshotData["hostBot"];
    this.challenger = _snapshotData["challenger"];
    this.challengerBot = _snapshotData["challengerBot"];
    this.hostReady = _snapshotData["hostReady"] ?? false;
  }

  Map<String, dynamic> serialize() {
    Map<String, dynamic> _map = {
      "host": host,
      "hostBot": hostBot,
      "challenger": challenger,
      "challengerBot": challengerBot,
      "hostReady": hostReady,
    };
    return _map;
  }
}
