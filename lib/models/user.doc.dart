class UserDoc {
  String uid;
  String displayName;
  String email;
  DateTime lastSeen;
  int nerdPoints;

  UserDoc({
    this.uid,
    this.displayName,
    this.email,
    this.lastSeen,
    this.nerdPoints,
  });

  UserDoc.fromFirestore(Map<String, dynamic> _snapshotData) {
    this.uid = _snapshotData["uid"];
    this.displayName = _snapshotData["displayName"] ?? "Guest";
    this.email = _snapshotData["email"];
    this.lastSeen = _snapshotData["lastSeen"];
    this.nerdPoints = _snapshotData["nerdPoints"] ?? 0;
  }

  Map<String, dynamic> toFireStore() {
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
