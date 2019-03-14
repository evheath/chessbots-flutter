import 'package:flutter/material.dart';

class ReadyButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () {},
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
}
