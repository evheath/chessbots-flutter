import 'package:flutter/material.dart';

class EnemyNotReadyButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () {},
      color: Colors.grey,
      child: SizedBox(
        width: double.infinity,
        child: Text(
          "Not Ready",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
