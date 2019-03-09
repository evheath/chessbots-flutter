import 'package:chessbotsmobile/models/chess_bot.dart';
import 'package:chessbotsmobile/pages/assemble.page.dart';
import 'package:chessbotsmobile/services/toaster.service.dart';
import 'package:chessbotsmobile/shared/custom.icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

//used on the bots.page
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
          return ExpansionTile(
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
            initiallyExpanded: true,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  IconButton(
                    onPressed: _bot.status == "damaged"
                        ? () => _repairDialog(context, _bot)
                        : null,
                    icon: Icon(FontAwesomeIcons.wrench),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push<ChessBot>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AssemblePage(_botRef),
                        ),
                      );
                    },
                    icon: Icon(MyCustomIcons.cog_alt),
                  ),
                  IconButton(
                    onPressed: () => _editDialog(context, _bot),
                    icon: Icon(FontAwesomeIcons.pencilAlt),
                  ),
                  IconButton(
                    onPressed: () => _sellDialog(context, _bot),
                    icon: Icon(FontAwesomeIcons.dollarSign),
                  ),
                ],
              )
            ],
          );
        });
  }

  void _sellDialog(BuildContext context, ChessBot _bot) {
    showDialog(
        context: context,
        builder: (context) {
          int sellValue = (_bot.value / 2).round();
          return AlertDialog(
            title: Text("Sell"),
            content: Text("Scrap ${_bot.name} for $sellValue nerd points?"),
            actions: <Widget>[
              FlatButton(
                child: Text("Noooo!"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text("Delete"),
                onPressed: () {
                  Navigator.of(context).pop();
                  _bot.event.add(DeleteBotDocEvent());
                },
              ),
            ],
          );
        });
  }

  void _editDialog(BuildContext context, ChessBot _bot) {
    final GlobalKey<FormState> _editFormKey = GlobalKey<FormState>();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Form(
              key: _editFormKey,
              child: AlertDialog(
                title: Text("Rename ${_bot.name}"),
                content: TextFormField(
                  initialValue: _bot.name,
                  // decoration: InputDecoration(
                  //   labelText: "Rename ${_bot.name}",
                  // ),
                  autofocus: true,
                  onSaved: (String name) {
                    // print("renaming $name");
                    _botRef.updateData({"name": name});
                    Navigator.pop(context);
                  },
                  validator: (name) {
                    if (name.isEmpty) {
                      return "You have to give it a name";
                    } else if (name.length > 20) {
                      return "Chill out, it is just a name";
                    }
                  },
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Discard"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  FlatButton(
                    child: Text("Save"),
                    onPressed: () {
                      if (_editFormKey.currentState.validate()) {
                        _editFormKey.currentState.save();
                      }
                    },
                  ),
                ],
              ));
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
