import 'package:chessbotsmobile/models/chess_bot.dart';
import 'package:chessbotsmobile/pages/assemble.page.dart';
import 'package:chessbotsmobile/pages/bot_detail.page.dart';
import 'package:chessbotsmobile/services/toaster.service.dart';
import 'package:chessbotsmobile/shared/custom.icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
              print("You tapped ${_bot.name}");
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
            // initiallyExpanded: true,
            // children: <Widget>[
            //   Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceAround,
            //     children: <Widget>[
            //       IconButton(
            //         onPressed: _bot.status == "damaged"
            //             ? () => _repairDialog(context, _bot)
            //             : null,
            //         icon: Icon(FontAwesomeIcons.wrench),
            //       ),
            //     ],
            //   )
            // ],
          );
        });
  }

  void _repairDialog(BuildContext context, ChessBot _bot) {
    showDialog(
        context: context,
        builder: (context) {
          int sellValue = (_bot.value / 2).round();
          return AlertDialog(
            title: Text("Sell"),
            content: Text("Repair ${_bot.name} for $sellValue nerd points?"),
            actions: <Widget>[
              FlatButton(
                child: Text("No"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text("Yes"),
                onPressed: () {
                  _bot
                      .attemptRepair()
                      .catchError((e) => handleError(e, context));
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
