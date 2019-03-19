import 'package:flutter/material.dart';

class WaitingButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: null,
      child: SizedBox(
        width: double.infinity,
        child: Text(
          "Waiting for challenger",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
