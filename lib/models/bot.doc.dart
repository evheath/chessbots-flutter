class BotDoc {
  String uid;
  String name;
  int kills;
  int level;
  int value;
  //TODO enum status some how
  String status;
  List<String> gambits = [];

  BotDoc({
    this.uid,
    this.name,
    this.level = 1,
    this.kills = 0,
    this.value = 0,
    this.status = "ready",
    this.gambits = const [],
  });

  BotDoc.fromSnapshot(Map<String, dynamic> _snapshotData) {
    this.uid = _snapshotData["uid"];
    this.name = _snapshotData["name"] ?? "Your bot";
    this.level = _snapshotData["level"];
    this.kills = _snapshotData["kills"];
    this.value = _snapshotData["value"];
    this.status = _snapshotData["status"];

    if (_snapshotData["gambits"] != null) {
      List<dynamic> _dynList = _snapshotData["gambits"];
      _dynList.forEach((element) {
        if (element is String) {
          this.gambits.add(element);
        }
      });
    }
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> _map = {
      "uid": uid,
      "name": name,
      "level": level,
      "kills": kills,
      "value": value,
      "status": status,
      "gambits": gambits,
    };
    return _map;
  }
}
