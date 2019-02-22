import 'package:flutter/material.dart';

import '../models/gambit.dart';

class GambitListTile extends StatelessWidget {
  final Gambit gambit;
  final Key key;

  GambitListTile({@required this.gambit, this.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(5.0),
          color: gambit.color.withAlpha(75),
        ),
        child: ListTile(
          title: Text(gambit.title),
          leading: CircleAvatar(
            child: gambit.vector,
            backgroundColor: gambit.color,
          ),
          trailing: GestureDetector(
            onTap: () {
              //TODO route to demo page
              print("you tapped the ${gambit.title} gambit");
            },
            child: Icon(Icons.help),
          ),
        ),
      ),
    );
  }
}
