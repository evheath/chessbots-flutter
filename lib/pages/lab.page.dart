import 'package:flutter/material.dart';

import '../shared/chess_board.dart';
import '../shared/left.drawer.dart';
import '../shared/custom.icons.dart';

//TODO remove after gambit testing
import '../shared/gambits.dart';

class LabPage extends StatefulWidget {
  @override
  LabPageState createState() {
    return LabPageState();
  }
}

class LabPageState extends State<LabPage> {
  bool _whiteSideTowardsUser = true;
  ChessBoardController _labBoardController = ChessBoardController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            //TODO display gambit used
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
              //TODO implement gambits
              // String move = MakeRandomMove().findMove(_labBoardController.game);
              // print('The move will be $move');
              // _labBoardController.makeMove(move);
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
