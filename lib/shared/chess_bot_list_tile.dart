import 'package:chessbotsmobile/models/bot.doc.dart';
import 'package:chessbotsmobile/shared/custom.icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// TODO:
// cogs link to assemble page
// pencil lets a rename occur
// wrench = repair
// dollar sign sells bot for 1/2 its value
class ChessBotListTile extends StatelessWidget {
  final DocumentReference _botRef;
  const ChessBotListTile(this._botRef);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BotDoc>(
        stream:
            _botRef.snapshots().map((snap) => BotDoc.fromSnapshot(snap.data)),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return ListTile(
              leading: CircularProgressIndicator(),
              title: Text("Loading"),
            );
          }
          BotDoc _botDoc = snapshot.data;
          return ExpansionTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${_botDoc.name}"),
                Text("Level ${_botDoc.level}"),
                Text("Value: ${_botDoc.value}"),
                Text("Kills: ${_botDoc.kills}"),
              ],
            ),
            trailing: Column(
              children: [
                CircleAvatar(
                  child:
                      FlareActor('animations/chessbot.flr', animation: 'idle'),
                  backgroundColor: Colors.transparent,
                ),
                Text("${_botDoc.status}"),
              ],
            ),
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  IconButton(
                    onPressed: () {},
                    icon: Icon(FontAwesomeIcons.wrench),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(MyCustomIcons.cog_alt),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(FontAwesomeIcons.pencilAlt),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(FontAwesomeIcons.dollarSign),
                  ),
                ],
              )
            ],
          );
        });
  }
}
