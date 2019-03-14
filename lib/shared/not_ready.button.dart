import 'package:flutter/material.dart';

class NotReadyButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () {},
      color: Colors.grey,
      child: SizedBox(
        width: double.infinity,
        child: Text(
          "Press to ready up",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
