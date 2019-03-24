import 'package:flutter/material.dart';

class PlayerNotReadyButton extends StatelessWidget {
  final Function onPressed;
  PlayerNotReadyButton({this.onPressed});
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: onPressed ?? () {},
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
