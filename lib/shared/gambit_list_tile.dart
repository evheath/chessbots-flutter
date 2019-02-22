import 'package:flutter/material.dart';

import '../models/gambit.dart';

class GambitListTile extends StatelessWidget {
  final Gambit gambit;
  final Key key;

  GambitListTile({@required this.gambit, this.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(gambit.title),
      trailing: CircleAvatar(
        child: gambit.vector,
        backgroundColor: gambit.color,
      ),
    );
  }
}
