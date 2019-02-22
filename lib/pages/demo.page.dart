import 'package:flutter/material.dart';
import '../models/gambit.dart';

class DemoPage extends StatelessWidget {
  final Gambit gambit;
  DemoPage(this.gambit);
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(gambit.title),
        backgroundColor: gambit.color,
        // leading: gambit.vector,
        // bottom: gambit.vector,
        centerTitle: true,
        actions: <Widget>[gambit.vector],
      ),
      body: Center(
        child: Text(gambit.description),
      ),
    );
  }
}
