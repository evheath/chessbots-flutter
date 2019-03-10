import 'package:chessbotsmobile/models/chess_bot.dart';
import 'package:chessbotsmobile/pages/bot_detail.page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

// used on the bots.page to display the bots the user owns
class ChessBotListTile extends StatelessWidget {
  final DocumentReference _botRef;
  const ChessBotListTile(this._botRef);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ChessBot>(
        stream: marshalChessBot(_botRef),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return ListTile(
              leading: CircularProgressIndicator(),
            );
          }
          ChessBot _bot = snapshot.data;
          return ListTile(
            onTap: () {
              // print("You tapped ${_bot.name}");
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BotDetailPage(_botRef),
                ),
              );
            },
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${_bot.name}"),
                Text("Level ${_bot.level}"),
                Text("Value: ${_bot.value}"),
                // Text("Kills: ${_bot.kills}"),
              ],
            ),
            trailing: Column(
              children: [
                CircleAvatar(
                  child:
                      FlareActor('animations/chessbot.flr', animation: 'idle'),
                  backgroundColor: Colors.transparent,
                ),
                Text("${_bot.status}"),
              ],
            ),
          );
        });
  }
}
