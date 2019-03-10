import 'package:chessbotsmobile/models/gambit.dart';
import 'package:chessbotsmobile/pages/assemble.page.dart';
import 'package:chessbotsmobile/pages/assemble.tutorial.dart';
import 'package:chessbotsmobile/pages/select_gambit.page.dart';
import 'package:chessbotsmobile/services/toaster.service.dart';
import 'package:chessbotsmobile/shared/custom.icons.dart';
import 'package:chessbotsmobile/shared/empty_list_tile.dart';
import 'package:chessbotsmobile/shared/gambit_list_tile.dart';
import 'package:chessbotsmobile/shared/gambits.dart';
import 'package:chessbotsmobile/shared/level_up_list_tile.dart';
import 'package:chessbotsmobile/shared/nerd_point_action_display.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
                  _buildGridTile(
                    label: "Rename ${_chessBot.name}",
                    iconData: FontAwesomeIcons.pencilAlt,
                    color: Colors.orange,
                    onPressed: () => _editDialog(context, _chessBot),
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
              // drawer: LeftDrawer(),
            );
          }
        });
  }

  FlatButton _buildGridTile({
    @required IconData iconData,
    @required String label,
    @required Color color,
    @required Function onPressed,
  }) {
    return FlatButton(
      onPressed: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            iconData,
            color: Colors.white,
          ),
          Text(
            label,
            style: TextStyle(color: Colors.white),
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
}
