import 'package:flutter/material.dart';

import '../bloc/base.bloc.dart';
import '../bloc/lab.bloc.dart';

import '../shared/chess_board.dart';
import '../shared/left.drawer.dart';
import '../shared/custom.icons.dart';

class LabPage extends StatefulWidget {
  @override
  LabPageState createState() {
    return LabPageState();
  }
}

class LabPageState extends State<LabPage> {
  bool whiteOnBottom = true;
  ChessBoardController controller;

  @override
  void initState() {
    print('initState() called');
    super.initState();
    controller = ChessBoardController();
    // whiteOnBottom = true;
  }

  @override
  Widget build(BuildContext context) {
    print('build() called');
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
      floatingActionButton: _buildFABs(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  } // Build

  Widget _buildFABs() {
    print('_buildFABs() called');
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        FloatingActionButton(
          onPressed: _logShit,
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
    );
  }

  Widget _buildChessBoard() {
    print('_buildChessBoard() called');
    return Container(
      child: ChessBoard(
        onMove: (move) {},
        onCheckMate: (color) {
          print('checkmate son');
          print(color);
        },
        onDraw: () {},
        size: MediaQuery.of(context).size.width - 20,
        enableUserMoves: true,
        chessBoardController: controller,
        whiteSideTowardsUser: whiteOnBottom,
      ),
    );
  }

  void _logShit() {
    print(controller.game.ascii);
    print(controller.game.fen);
  }

  void _resetGame() {
    controller.resetBoard();
    // gameMoves.clear();
    setState(() {});
  }

  void _flipBoard() {
    whiteOnBottom = !whiteOnBottom;
    // controller.refreshBoard();
    // setState(() {
    //   whiteOnBottom = !whiteOnBottom;
    //   controller = controller;
    // });
  }
}
