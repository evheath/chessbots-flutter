import 'package:chessbotsmobile/models/bot.doc.dart';
import 'package:chessbotsmobile/shared/custom.icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
            return ListTile(leading: CircularProgressIndicator());
          }
          BotDoc _botDoc = snapshot.data;
          return ExpansionTile(
            title: Text("${_botDoc.name}"),
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
