import 'package:chessbotsmobile/bloc/firestore.bloc.dart';
import 'package:chessbotsmobile/shared/level_up_list_tile.dart';
import 'package:chessbotsmobile/shared/nerd_point_action_display.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import './assemble.tutorial.dart';
import '../shared/empty_list_tile.dart';
import 'package:flutter/material.dart';
import '../shared/left.drawer.dart';
import '../shared/custom.icons.dart';
import '../bloc/base.bloc.dart';
import '../bloc/chess_bot.bloc.dart';
import '../models/gambit.dart';
import '../shared/gambits.dart';
import '../shared/gambit_list_tile.dart';
import '../pages/select_gambit.page.dart';

class NewAssemblePage extends StatefulWidget {
  final DocumentReference botRef;
  const NewAssemblePage(this.botRef);
  @override
  NewAssemblePageState createState() {
    return NewAssemblePageState();
  }
}

class NewAssemblePageState extends State<NewAssemblePage> {
  ValueObservable<DocumentSnapshot> _botDocSnap$;
  @override
  void initState() {
    _botDocSnap$ = Observable(widget.botRef.snapshots()).shareValue();
    _checkIfNeverSeenTutorial();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
          stream: _botDocSnap$,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              ChessBot _chessBot = ChessBot.fromFirestore(snapshot.data.data);
              return Container(
                padding: EdgeInsets.all(10.0),
                child: StreamBuilder(
                  initialData: [
                    MoveRandomPiece()
                  ], // needed for error prevention
                  stream: _chessBot.gambits,
                  builder: (context, snapshot) {
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
        leading: Builder(
          builder: (context) {
            // TODO implement this button style on other pages
            // instead of relying on default hamburger button
            return IconButton(
              icon: const Icon(MyCustomIcons.cog_alt),
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          },
        ),
        title: Wrap(
          children: [
            FutureBuilder<DocumentSnapshot>(
                future: _botDocSnap$.first,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    ChessBot _bot = ChessBot.fromFirestore(snapshot.data.data);
                    return Text("${_bot.name}");
                  } else {
                    return Text("Build your bot");
                  }
                }),
          ],
        ),
        actions: <Widget>[
          NerdPointActionDisplay(),
        ],
      ),
      drawer: LeftDrawer(),
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
    //TODO is there a way to do this in bloc?
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
                            builder: (context) => SelectGambitPage()))
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

  void _displayError(String e) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            // title: Text("Problem"),
            content: Text(e),
            actions: <Widget>[
              FlatButton(
                  child: Text("Ah shucks"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  })
            ],
          );
        });
  }

  void _levelUpPrompt(ChessBot _chessBot) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Level Up?"),
          content: Text("Spend 1 nerd point to unlock a new gambit slot?"),
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
                FirestoreBloc()
                    .firestoreEvent
                    .add(AddEmptyGambitEvent(_chessBot, widget.botRef));
                Navigator.of(context).pop();
                // TODO eventually the calcuation should be dynamic
                // such as growing with number of gambits
                // final int _nerdPointsToBeSpent = 1;
                // FirestoreBloc().spendNerdPoints(_nerdPointsToBeSpent).then((_) {
                // THE ADDING SHOULDNT EVEN HAPPEN TO THE CHESS BOT
                // IT SHOULD BE SYNCED WITH FIREBASE WHERE THE ADDING HAPPENS
                // _chessBot.event.add(AddEmptyGambitEvent());

                //   FirestoreBloc()
                //       .firestoreEvent
                //       .add(AddEmptyGambitEvent(_chessBot, widget.botRef));
                //   Navigator.of(context).pop();
                // }).catchError((e) {
                //   print(e);
                //   // need to pop first, since display error has its own context
                //   Navigator.of(context).pop();
                //   _displayError(e);
                // });
              },
            ),
          ],
        );
      },
    );
  }
}
