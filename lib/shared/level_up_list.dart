import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LevelUpTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.black54,
        ),
        child: ListTile(
          leading: CircleAvatar(
            child: Icon(FontAwesomeIcons.lockOpen, color: Colors.white),
            backgroundColor: Colors.black,
          ),
          title: Text("Unlock a gambit slot!"),
        ),
      ),
    );
  }
}
