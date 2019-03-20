import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PlayerNotReadyButton extends StatefulWidget {
  final DocumentReference lobbyRef;
  final bool playerIsHost;
  PlayerNotReadyButton(this.lobbyRef, this.playerIsHost);
  @override
  _PlayerNotReadyButtonState createState() => _PlayerNotReadyButtonState();
}

class _PlayerNotReadyButtonState extends State<PlayerNotReadyButton> {
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: _loading ? () {} : setReadyToTrue,
      color: Colors.grey,
      child: SizedBox(
        width: double.infinity,
        child: _loading
            ? CircularProgressIndicator()
            : Text(
                "Press to ready up",
                textAlign: TextAlign.center,
              ),
      ),
    );
  }

  setReadyToTrue() async {
    _loading = true;
    String field = widget.playerIsHost ? "hostReady" : "challengerReady";
    await widget.lobbyRef.updateData({field: true});
    _loading = false;
  }
}
