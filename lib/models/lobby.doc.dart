import 'package:cloud_firestore/cloud_firestore.dart';

class LobbyDoc {
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

  LobbyDoc.fromFirestore(Map<String, dynamic> _snapshotData) {
    this.createdAt = _snapshotData["createdAt"];
    this.host = _snapshotData["host"];
    this.hostBot = _snapshotData["hostBot"];
    this.challenger = _snapshotData["challenger"];
    this.challengerBot = _snapshotData["challengerBot"];
    this.hostReady = _snapshotData["hostReady"] ?? false;
  }

  Map<String, dynamic> serialize() {
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
