import 'package:flutter/material.dart';

import '../shared/left.drawer.dart';

class LabPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("LAB"),
      ),
      drawer: LeftDrawer(),
    );
  }
}
