// import 'package:chessbotsmobile/bloc/firestore.bloc.dart';
import 'package:chessbotsmobile/bloc/game_controller.bloc.dart';
// import 'package:chessbotsmobile/pages/bots.page.dart';
import 'package:chessbotsmobile/shared/chess_board.dart';
// import 'package:chessbotsmobile/shared/custom.icons.dart';
// import 'package:chessbotsmobile/shared/left.drawer.dart';
import 'package:chessbotsmobile/shared/nerd_point_action_display.dart';
import 'package:chessbotsmobile/shared/status.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chessbotsmobile/models/chess_bot.dart';

class LabPage extends StatefulWidget {
  final DocumentReference botRef;
  const LabPage(this.botRef);
  @override
  LabPageState createState() {
    return LabPageState();
  }
}

class LabPageState extends State<LabPage> {
  GameControllerBloc _labBoardController = GameControllerBloc();
  // ChessBot _chessBot;
  // DocumentReference _selectedBot;

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
    // if (_selectedBot == null) {
    //   presentSelectBotDialog();
    // }

    return StreamBuilder<ChessBot>(
        stream: marshalChessBot(widget.botRef),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
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
                  Status(_chessBot),
                ],
              ),
            ),
            appBar: AppBar(
              // leading: Builder(builder: (context) {
              //   return IconButton(
              //     icon: const Icon(MyCustomIcons.beaker),
              //     onPressed: () => Scaffold.of(context).openDrawer(),
              //   );
              // }),
              title: Text("Lab"),
              centerTitle: true,
              actions: [NerdPointActionDisplay()],
              backgroundColor: Colors.purple,
            ),
            // drawer: LeftDrawer(),
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
                  onPressed: () => _labBoardController.resetBoard(),
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
}
