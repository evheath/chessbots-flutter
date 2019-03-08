import 'package:flutter/material.dart';
import '../bloc/chess_bot.bloc.dart';
import 'package:flare_flutter/flare_actor.dart';

///New, stream-based status tile
class OpponentListTile extends StatelessWidget {
  final ChessBot bot;

  OpponentListTile(this.bot);

  @override
  Widget build(BuildContext context) {
    // final AuthBloc _firestoreBloc = BlocProvider.of<AuthBloc>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${bot.name}"),
              Text("Level ${bot.level}"),
              Text("Bounty: ${bot.bounty}"),
            ],
          ),
          trailing: CircleAvatar(
            child: FlareActor('animations/chessbot.flr', animation: 'idle'),
            backgroundColor: Colors.transparent,
          ),
        ),
      ),
    );
  }
}
