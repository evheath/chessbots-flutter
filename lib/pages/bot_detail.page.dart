import 'package:chessbotsmobile/pages/assemble.page.dart';
import 'package:chessbotsmobile/pages/lab.page.dart';
import 'package:chessbotsmobile/pages/singleplayer.page.dart';
import 'package:chessbotsmobile/services/toaster.service.dart';
import 'package:chessbotsmobile/shared/custom.icons.dart';
import 'package:chessbotsmobile/shared/nerd_point_action_display.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:chessbotsmobile/models/chess_bot.dart';

class BotDetailPage extends StatefulWidget {
  final DocumentReference botRef;
  const BotDetailPage(this.botRef);

  @override
  _BotDetailPageState createState() => _BotDetailPageState();
}

class _BotDetailPageState extends State<BotDetailPage> {
  String animationToPlay = 'idle';
  Widget build(BuildContext context) {
    //TODO if i return to bloc pattern
    // here is where i could store the bot for all sub routes
    // that way I wouldn't have to do a read at each page
    // I am not sure how sub routes would get affected by a bot changing, and everything below gets rebuilt by a stream buidler

    return StreamBuilder<ChessBot>(
        stream: marshalChessBot(widget.botRef),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            ChessBot _chessBot = snapshot.data;
            return Scaffold(
              body: GridView.count(
                crossAxisCount: 2,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        animationToPlay = 'mad';
                      });
                      Future.delayed(Duration(seconds: 2), () {
                        setState(() {
                          animationToPlay = 'idle';
                        });
                      });
                    },
                    child: FlareActor(
                      'animations/chessbot.flr',
                      animation: animationToPlay,
                      fit: BoxFit.cover,
                    ),
                  ),
                  _buildGridTile(
                    label: "Edit ${_chessBot.name}'s gambits",
                    iconData: MyCustomIcons.cog_alt,
                    color: Colors.grey,
                    onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AssemblePage(widget.botRef),
                          ),
                        ),
                  ),
                  _buildGridTile(
                    label: "Singleplayer",
                    iconData: FontAwesomeIcons.userAlt,
                    color: Colors.lightBlueAccent,
                    onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SingleplayerPage(widget.botRef),
                          ),
                        ),
                  ),
                  _buildGridTile(
                    label: "Test ${_chessBot.name}'s gambits in the Lab",
                    iconData: MyCustomIcons.beaker,
                    color: Colors.purple,
                    onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LabPage(widget.botRef),
                          ),
                        ),
                  ),
                  _buildGridTile(
                    label: "Rename ${_chessBot.name}",
                    iconData: FontAwesomeIcons.pencilAlt,
                    color: Colors.orange,
                    onPressed: () => _editDialog(context, _chessBot),
                  ),
                  _buildGridTile(
                    label: "Repair ${_chessBot.name}",
                    iconData: FontAwesomeIcons.wrench,
                    color: Colors.redAccent,
                    onPressed: () => _repairDialog(context, _chessBot),
                    disabled: _chessBot.status != "damaged",
                  ),
                  _buildGridTile(
                    label: "Sell ${_chessBot.name}",
                    iconData: FontAwesomeIcons.dollarSign,
                    color: Colors.green,
                    onPressed: () => _sellDialog(context, _chessBot),
                  )
                ],
              ),
              appBar: AppBar(
                centerTitle: true,
                title: Wrap(
                  children: [Text("${_chessBot.name}")],
                ),
                actions: <Widget>[
                  NerdPointActionDisplay(),
                ],
              ),
            );
          }
        });
  }

  FlatButton _buildGridTile({
    @required IconData iconData,
    @required String label,
    @required Color color,
    @required Function onPressed,
    bool disabled = false,
  }) {
    return FlatButton(
      onPressed: disabled ? null : onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            iconData,
            color: disabled ? Colors.black : Colors.white,
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: disabled ? Colors.black : Colors.white,
            ),
          ),
        ],
      ),
      color: color,
    );
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
                    widget.botRef.updateData({"name": name});
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

  void _sellDialog(BuildContext context, ChessBot _bot) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Sell"),
            content:
                Text("Scrap ${_bot.name} for ${_bot.sellValue} nerd points?"),
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
                  Navigator.of(context).pop(); // close dialog
                  _bot.event.add(DeleteBotDocEvent());
                  Navigator.pushReplacementNamed(context, '/');
                },
              ),
            ],
          );
        });
  }

  void _repairDialog(BuildContext context, ChessBot _bot) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Repair"),
            content:
                Text("Repair ${_bot.name} for ${_bot.repairCost} nerd points?"),
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
