import 'package:cloud_firestore/cloud_firestore.dart';

class UserDoc {
  String uid;
  String displayName;
  String email;
  DateTime lastSeen;
  int nerdPoints;
  List<DocumentReference> bots = [];

  /// Titles of gambits the user has purchased
  List<String> ownedGambits = [];

  UserDoc({
    this.uid,
    this.displayName = "Guest",
    this.email,
    this.lastSeen,
    this.nerdPoints = 0,
  });

  UserDoc.fromFirestore(Map<String, dynamic> _snapshotData) {
    this.uid = _snapshotData["uid"];
    this.displayName = _snapshotData["displayName"] ?? "Guest";
    this.email = _snapshotData["email"];
    this.lastSeen = _snapshotData["lastSeen"];
    this.nerdPoints = _snapshotData["nerdPoints"] ?? 0;

    if (_snapshotData["bots"] != null) {
      List<dynamic> _dynList = _snapshotData["bots"];
      _dynList.forEach((element) {
        if (element is DocumentReference) {
          this.bots.add(element);
        }
      });
    }

    if (_snapshotData["ownedGambits"] != null) {
      List<dynamic> _dynList = _snapshotData["ownedGambits"];
      _dynList.forEach((element) {
        if (element is String) {
          this.ownedGambits.add(element);
        }
      });
    }
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> _map = {
      "uid": uid,
      "displayName": displayName,
      "email": email,
      "lastSeen": lastSeen,
      "nerdPoints": nerdPoints,
    };
    return _map;
  }
}
