import 'package:flutter/material.dart';
import '../pages/demo.page.dart';
import '../pages/select_gambit.page.dart';
import '../models/gambit.dart';
import '../shared/gambits/empty.dart';

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
            child: Icon(gambit.icon, color: Colors.white),
            backgroundColor: gambit.color,
          ),
          trailing: GestureDetector(
            onTap: () {
              if (gambit == EmptyGambit()) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SelectGambitPage()));
              } else {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => DemoPage(gambit)));
              }
            },
            child: Icon(Icons.help),
          ),
        ),
      ),
    );
  }
}
