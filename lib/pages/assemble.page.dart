import 'package:chessbotsmobile/models/gambit.dart';
import 'package:chessbotsmobile/pages/assemble.tutorial.dart';
import 'package:chessbotsmobile/pages/select_gambit.page.dart';
import 'package:chessbotsmobile/services/toaster.service.dart';
import 'package:chessbotsmobile/shared/empty_list_tile.dart';
import 'package:chessbotsmobile/shared/gambit_list_tile.dart';
import 'package:chessbotsmobile/shared/gambits.dart';
import 'package:chessbotsmobile/shared/level_up_list_tile.dart';
import 'package:chessbotsmobile/shared/nerd_point_action_display.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:chessbotsmobile/models/chess_bot.dart';

class AssemblePage extends StatefulWidget {
  final DocumentReference botRef;
  const AssemblePage(this.botRef);
  @override
  AssemblePageState createState() {
    return AssemblePageState();
  }
}

class AssemblePageState extends State<AssemblePage> {
  @override
  void initState() {
    _checkIfNeverSeenTutorial();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<ChessBot>(
          stream: marshalChessBot(widget.botRef),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              ChessBot _chessBot = snapshot.data;
              return Container(
                padding: EdgeInsets.all(10.0),
                child: StreamBuilder(
                  stream: _chessBot.gambits,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return (Center(child: CircularProgressIndicator()));
                    }
                    List<Gambit> _gambits = snapshot.data;
                    return ReorderableListView(
                      scrollDirection: Axis.vertical,
                      onReorder: (oldIndex, newIndex) {
                        _chessBot.event.add(ReorderEvent(oldIndex, newIndex));
                      },
                      header: GambitListTile(gambit: CheckmateOpponent()),
                      children: _buildGambitListTiles(_gambits, _chessBot),
                    );
                  },
                ),
              );
            }
          }),
      appBar: AppBar(
        title: Wrap(
          children: [Text("Assemble gambits")],
        ),
        actions: <Widget>[
          NerdPointActionDisplay(),
        ],
      ),
      // drawer: LeftDrawer(),
    );
  } // Build

  void _showTutorial() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AssembleTutorial(),
        fullscreenDialog: true,
      ),
    ).then((_) async {
      // marking the tutorial as seen
      final SharedPreferences _prefsInstance =
          await SharedPreferences.getInstance();
      _prefsInstance.setBool("seenAssembleTutorial", true);
    });
  }

  Future<void> _checkIfNeverSeenTutorial() async {
    final SharedPreferences _prefsInstance =
        await SharedPreferences.getInstance();
    final seenAssembleTutorial =
        _prefsInstance.getBool('seenAssembleTutorial') ?? false;
    if (!seenAssembleTutorial) {
      _showTutorial();
    }
  }

  List<Widget> _buildGambitListTiles(
      List<Gambit> _gambits, ChessBot _chessBot) {
    //configurable gambits first
    List<Widget> _gambitTiles = List.generate(_gambits.length, (index) {
      Gambit _gambit = _gambits[index];
      return _gambit == EmptyGambit()
          ? GestureDetector(
              // if the gambit is empty
              key: Key(_gambit.title),
              child: EmptyListTile(),
              onTap: () {
                Navigator.push<Gambit>(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SelectGambitPage(_chessBot)))
                    .then((Gambit selectedGambit) {
                  if (selectedGambit != null) {
                    _chessBot.event
                        .add(SelectGambitEvent(index, selectedGambit));
                  }
                });
              },
            )
          : Dismissible(
              // if it is a regular gambit
              resizeDuration: Duration(microseconds: 1),
              direction: DismissDirection.horizontal,
              key: Key(_gambit.title),
              child: GambitListTile(
                gambit: _gambit,
              ),
              onDismissed: (direction) {
                // swiping a list tile will replace it with an empty gambit
                _chessBot.event.add(DismissedEvent(index));
              },
              background: EmptyListTile(),
            );
    });

    // gambits that are always added to the end
    _gambitTiles.addAll([
      GambitListTile(
        gambit: MoveRandomPiece(),
        key: Key(MoveRandomPiece().title),
      ),
      GestureDetector(
        key: Key("Level up"),
        child: LevelUpTile(),
        onTap: () {
          _levelUpPrompt(_chessBot);
        },
      ),
    ]);

    return _gambitTiles;
  }

  void _levelUpPrompt(ChessBot _chessBot) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Level Up?"),
          content: Text(
              "Spend ${_chessBot.costOfUpgrading()} nerd point to unlock a new gambit slot?"),
          actions: <Widget>[
            FlatButton(
              child: Text("Nah"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop();
                _chessBot
                    .attemptLevelUp()
                    .catchError((e) => handleError(e, context));
              },
            ),
          ],
        );
      },
    );
  }
}
