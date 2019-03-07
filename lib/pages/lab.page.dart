import 'package:chessbotsmobile/bloc/firestore.bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../shared/chess_board.dart';
import '../shared/left.drawer.dart';
import '../shared/custom.icons.dart';
import '../shared/status.dart';
import '../bloc/base.bloc.dart';
import '../bloc/chess_bot.bloc.dart';
import '../bloc/game_controller.bloc.dart';

class LabPage extends StatefulWidget {
  //TODO this page needs to accept a bot, or let the player choose the bot
  // Getting a bot through the BlocProvider will be going away
  @override
  LabPageState createState() {
    return LabPageState();
  }
}

class LabPageState extends State<LabPage> {
  GameControllerBloc _labBoardController = GameControllerBloc();
  // ChessBot _chessBot;
  DocumentReference _selectedBot;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _labBoardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedBot == null) {
      presentSelectBotDialog();
    }

    return StreamBuilder<ChessBot>(
        stream: marshalChessBot(_selectedBot),
        initialData: ChessBot(name: "Pending selection"),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Scaffold(
              body: Center(
                child: CircleAvatar(),
              ),
            );
          }
          ChessBot _chessBot = snapshot.data;
          return Scaffold(
            body: Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  ChessBoard(
                    moveAnyPiece: true,
                    size: MediaQuery.of(context).size.width - 20,
                    enableUserMoves: true,
                    chessBoardController: _labBoardController,
                    onMove: (move) {},
                    onCheckMate: (derp) {},
                    onDraw: () {},
                  ),
                  GestureDetector(
                    onTap: presentSelectBotDialog,
                    child: Status(_chessBot),
                  )
                ],
              ),
            ),
            appBar: AppBar(
              title: Row(
                children: [
                  Icon(MyCustomIcons.beaker),
                  SizedBox(width: 10.0),
                  Text("LAB"),
                ],
              ),
            ),
            drawer: LeftDrawer(),
            floatingActionButton: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FloatingActionButton(
                  onPressed: () {
                    if (!_labBoardController.game.in_checkmate) {
                      String move =
                          _chessBot.waterfallGambits(_labBoardController.game);
                      _labBoardController.labMove(move);
                    }
                  },
                  tooltip: 'Test gambits',
                  child: Icon(Icons.play_arrow),
                ),
                FloatingActionButton(
                  onPressed: () {
                    _labBoardController.resetBoard();
                    setState(() {});
                  },
                  tooltip: 'Reset',
                  child: Icon(Icons.repeat),
                ),
              ],
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
        });
  } // Build

  void presentSelectBotDialog() async {
    final _currentUserData = await FirestoreBloc().userDoc$.first;
    final _botrefs = _currentUserData.bots;
    showDialog(
        context: context,
        builder: (context) => SimpleDialog(
              title: Text("Select your bot"),
              children: List.generate(_botrefs.length, (index) {
                return _buildSelectListTile(_botrefs[index]);
              }),
            ));
  }

  Widget _buildSelectListTile(DocumentReference _ref) {
    return StreamBuilder<ChessBot>(
      stream: marshalChessBot(_ref),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return ListTile(
            leading: CircularProgressIndicator(),
          );
        } else {
          ChessBot _bot = snapshot.data;
          return ListTile(
            title: Text("${_bot.name}"),
            onTap: () {
              setState(() {
                _selectedBot = _ref;
              });
              Navigator.pop(context);
            },
          );
        }
      },
    );
  }
}
