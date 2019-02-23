import 'package:flutter/material.dart';
import '../models/gambit.dart';

class StatusListTile extends StatelessWidget {
  final Gambit gambit;

  //TODO incorporate player info and chessbot face
  StatusListTile({@required this.gambit});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
            // border: Border.all(),
            // borderRadius: BorderRadius.circular(5.0),
            // color: gambit.color.withAlpha(75),
            ),
        child: ListTile(
          //robot face should be under title, player data under leading
          leading: Text("LEVEL100"),
          title: Icon(Icons.directions_railway),
          trailing: CircleAvatar(
            child: Icon(gambit.icon, color: Colors.white),
            backgroundColor: gambit.color,
          ),
        ),
      ),
    );
  }
}
