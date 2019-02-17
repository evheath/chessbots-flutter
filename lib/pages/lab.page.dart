import 'package:flutter/material.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';

import '../shared/left.drawer.dart';
import '../shared/custom.icons.dart';

class LabPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: Text('Hello world'),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ChessBoard(
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
            )
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
            onPressed: () {},
            tooltip: 'Swap',
            child: Icon(Icons.shuffle),
          ),
          FloatingActionButton(
            onPressed: () {},
            tooltip: 'Reset',
            child: Icon(Icons.repeat),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
