import 'package:chessbotsmobile/pages/multiplayer_match.page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void handleError(dynamic error, BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Problem"),
        content: Text(error.toString()),
        actions: <Widget>[
          FlatButton(
            child: Text("Dismiss"),
            onPressed: () => Navigator.pop(context),
          )
        ],
      );
    },
  );
}

void handleRejoinMatch(DocumentReference matchRef, BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Rejoin match?"),
        content: Text("Looks like you have an active match."),
        actions: <Widget>[
          // FlatButton(
          //   child: Text("Dismiss"),
          //   onPressed: () => Navigator.pop(context),
          // ),
          FlatButton(
            child: Text("Rejoin"),
            onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MultiplayerMatchPage(
                          matchRef: matchRef,
                        ),
                  ),
                ),
          )
        ],
      );
    },
  );
}
