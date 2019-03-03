import 'package:flutter/material.dart';
import '../shared/chess_board.dart';
import '../shared/left.drawer.dart';
import '../shared/custom.icons.dart';
import '../shared/status.dart';
import '../bloc/base.bloc.dart';
import '../bloc/chess_bot.bloc.dart';
import '../bloc/game_controller.bloc.dart';

class LabPage extends StatefulWidget {
  @override
  LabPageState createState() {
    return LabPageState();
  }
}

class LabPageState extends State<LabPage> {
  GameControllerBloc _labBoardController = GameControllerBloc();

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
    final ChessBot _chessBot = BlocProvider.of<ChessBot>(context);

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
            Status(
              _chessBot,
            ),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  } // Build

}
