import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReadyButton extends StatelessWidget {
  final DocumentReference lobbyRef;

  ///if playerIsHost is passed in (for toggling purposes)
  ///then the lobbyRef MUST be passed in
  final bool playerIsHost;
  ReadyButton({this.playerIsHost, this.lobbyRef});
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: playerIsHost == null ? () {} : setReadyToFalse,
      color: Colors.green,
      child: SizedBox(
        width: double.infinity,
        child: Text(
          "Ready",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  setReadyToFalse() async {
    String field = playerIsHost ? "hostReady" : "challengerReady";
    await lobbyRef.updateData({field: false});
  }
}
