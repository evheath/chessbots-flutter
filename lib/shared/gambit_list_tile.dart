import 'package:flutter/material.dart';

import '../models/gambit.dart';

class GambitListTile extends StatelessWidget {
  Gambit _gambit;

  GambitListTile(this._gambit);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: Key(_gambit.title),
      title: Text(_gambit.title),
      trailing: CircleAvatar(
        child: _gambit.vector,
        backgroundColor: _gambit.color,
      ),
    );
  }
}
