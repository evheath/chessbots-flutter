import 'package:chessbotsmobile/shared/gambits/empty.dart';
import 'package:flutter/material.dart';
import 'package:chessbotsmobile/models/gambit.dart';
import 'package:chessbotsmobile/models/chess_bot.dart';
import 'package:flare_flutter/flare_actor.dart';

///New, stream-based status tile
class Status extends StatelessWidget {
  final ChessBot bot;

  Status(this.bot);

  @override
  Widget build(BuildContext context) {
    // final AuthBloc _firestoreBloc = BlocProvider.of<AuthBloc>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
            // border: Border.all(),
            // borderRadius: BorderRadius.circular(5.0),
            // color: gambit.color.withAlpha(75),
            ),
        child: ListTile(
          leading: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${bot.name}"),
              Text("Level ${bot.level}"),
              Text("Bounty: ${bot.bounty}np"),
              // Text("Kills: ${bot.kills}"),
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
