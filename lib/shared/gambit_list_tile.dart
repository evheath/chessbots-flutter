import 'package:flutter/material.dart';
import '../pages/demo.page.dart';
import '../models/gambit.dart';

class GambitListTile extends StatelessWidget {
  final Gambit gambit;
  final Key key;
  final bool disabled;

  GambitListTile({@required this.gambit, this.key, this.disabled = false});

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
          enabled: !disabled,
          title: Text(
            gambit.title,
            softWrap: false,
          ),
          leading: Hero(
            tag: gambit.title,
            child: CircleAvatar(
              child: Icon(gambit.icon, color: Colors.white),
              backgroundColor: gambit.color,
            ),
          ),
          trailing: IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => DemoPage(gambit)));
            },
            icon: Icon(Icons.help),
          ),
        ),
      ),
    );
  }
}
