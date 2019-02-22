import 'package:flutter/material.dart';

import '../shared/chess_board.dart';
import '../shared/left.drawer.dart';
import '../shared/custom.icons.dart';
import '../shared/status_list_tile.dart';
import '../shared/gambits.dart';

import '../bloc/base.bloc.dart';
import '../bloc/gambits.bloc.dart';
import '../models/gambit.dart';

class LabPage extends StatefulWidget {
  @override
  LabPageState createState() {
    return LabPageState();
  }
}

class LabPageState extends State<LabPage> {
  bool _whiteSideTowardsUser = true;
  ChessBoardController _labBoardController = ChessBoardController();
  Gambit _lastGambitUsed = CaptureBishop(); //TODO: empty gambit?

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final GambitsBloc _gambitsBloc = BlocProvider.of<GambitsBloc>(context);
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            ChessBoard(
              //TODO moveAnyPiece: true,
              size: MediaQuery.of(context).size.width - 20,
              enableUserMoves: true,
              chessBoardController: _labBoardController,
              whiteSideTowardsUser: _whiteSideTowardsUser,
              onMove: (move) {},
              onCheckMate: (derp) {},
              onDraw: () {},
            ),
            //TODO GambitAvatar instead of ListTile
            StatusListTile(gambit: _lastGambitUsed),
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
              // String move =
              //     _gambitsBloc.waterfallGambits(_labBoardController.game);
              // print('The move will be $move');
              setState(() {
                _lastGambitUsed =
                    _gambitsBloc.gambitToBeUsed(_labBoardController.game);
              });
              var move = _lastGambitUsed.findMove(_labBoardController.game);
              _labBoardController.makeMove(move);
            },
            tooltip: 'Test gambits',
            child: Icon(Icons.play_arrow),
          ),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                _whiteSideTowardsUser = !_whiteSideTowardsUser;
              });
            },
            tooltip: 'Swap',
            child: Icon(Icons.shuffle),
          ),
          FloatingActionButton(
            onPressed: () {
              _labBoardController.resetBoard();
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
