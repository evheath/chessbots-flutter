import 'package:flutter/material.dart';

class LoadingListTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          title: Text("Loading..."),
          leading: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
