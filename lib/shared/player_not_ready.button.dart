import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PlayerNotReadyButton extends StatefulWidget {
  final DocumentReference lobbyRef;
  PlayerNotReadyButton(this.lobbyRef);
  @override
  _PlayerNotReadyButtonState createState() => _PlayerNotReadyButtonState();
}

class _PlayerNotReadyButtonState extends State<PlayerNotReadyButton> {
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: _loading ? () {} : toggleReady,
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

  toggleReady() async {
    _loading = true;
    await widget.lobbyRef.updateData({"hostReady": true});
    _loading = false;
  }
}
