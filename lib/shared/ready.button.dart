import 'package:flutter/material.dart';

class ReadyButton extends StatelessWidget {
  //TODO consider loading stream on lobby blob
  // since the bloc will be passed down via context to this button
  final Function onPressed;
  ReadyButton({this.onPressed});
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: onPressed ?? () {},
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
