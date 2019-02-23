import 'package:flutter/material.dart';

class EmptyListTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.white,
        ),
        child: ListTile(
          title: Text("Empty"),
        ),
      ),
    );
  }
}
