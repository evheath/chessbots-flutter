import 'package:flutter/material.dart';

class PlayerNotReadyButton extends StatelessWidget {
  //TODO consider loading stream on lobby blob
  // since the bloc will be passed down via context to this button
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
