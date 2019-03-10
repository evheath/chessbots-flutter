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
      });
}
