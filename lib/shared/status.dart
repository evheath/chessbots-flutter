import 'package:chessbotsmobile/shared/gambits/empty.dart';
import 'package:flutter/material.dart';
import 'package:chessbotsmobile/models/gambit.dart';
import 'package:chessbotsmobile/models/chess_bot.dart';
import 'package:flare_flutter/flare_actor.dart';

class Status extends StatelessWidget {
  final ChessBot bot;
  final bool white;
  String color;

  Status(this.bot, {this.white = false}) {
    color = white ? "White" : "Black";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          // border: Border.all(),
          // borderRadius: BorderRadius.circular(5.0),
          color: white ? Colors.white : Colors.black,
        ),
        child: ListTile(
          leading: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${bot.name}",
                style: TextStyle(color: !white ? Colors.white : Colors.black),
              ),
              Text(
                "Gambits: ${bot.level}",
                style: TextStyle(color: !white ? Colors.white : Colors.black),
              ),
              Text(
                "Bounty: ${bot.bounty}np",
                style: TextStyle(color: !white ? Colors.white : Colors.black),
              ),
            ],
          ),
          title: SizedBox(
            height: 75,
            child: FlareActor(
              'animations/chessbot.flr',
              animation: 'idle',
            ),
          ),
          trailing: StreamBuilder<Gambit>(
              initialData: EmptyGambit(),
              stream: bot.lastUsedGambit,
              builder: (context, snapshot) {
                Gambit gambit = snapshot.data;
                return CircleAvatar(
                  child: Icon(gambit.icon, color: Colors.white),
                  backgroundColor: gambit.color,
                );
              }),
        ),
      ),
    );
  }
}
