import 'package:flutter/material.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';

import '../shared/left.drawer.dart';
import '../shared/custom.icons.dart';

class LabPage extends StatefulWidget {
  @override
  LabPageState createState() {
    return new LabPageState();
  }
}

class LabPageState extends State<LabPage> {
  bool whiteOnBottom;
  ChessBoardController controller;

  @override
  void initState() {
    super.initState();
    controller = ChessBoardController();
    whiteOnBottom = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: Text('Hello world'),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildChessBoard(),
          ],
        ),
      ),
      appBar: AppBar(
        title: Row(
          // mainAxisAlignment: MainAxisAlignment.center,
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
            onPressed: () {},
            tooltip: 'Test gambits',
            child: Icon(Icons.play_arrow),
          ),
          FloatingActionButton(
            onPressed: _flipBoard,
            tooltip: 'Swap',
            child: Icon(Icons.shuffle),
          ),
          FloatingActionButton(
            onPressed: _resetGame,
            tooltip: 'Reset',
            child: Icon(Icons.repeat),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  } // Build

  Widget _buildChessBoard() {
    return ChessBoard(
      onMove: (move) {
        print(move);
      },
      onCheckMate: (color) {
        print('checkmate son');
        print(color);
      },
      onDraw: () {},
      size: MediaQuery.of(context).size.width - 20,
      enableUserMoves: true,
      chessBoardController: controller,
      whiteSideTowardsUser: whiteOnBottom,
    );
  }

  void _resetGame() {
    controller.resetBoard();
    // gameMoves.clear();
    setState(() {});
  }

  void _flipBoard() {
    // controller.resetBoard();
    whiteOnBottom = !whiteOnBottom;
    // gameMoves.clear();
    setState(() {});
  }
}
