import 'package:flutter/material.dart';
import '../models/gambit.dart';
import '../shared/chess_board.dart';

class DemoPage extends StatefulWidget {
  final Gambit gambit;
  DemoPage(this.gambit);

  @override
  DemoPageState createState() {
    return new DemoPageState();
  }
}

class DemoPageState extends State<DemoPage> {
  ChessBoardController _demoBoardController = ChessBoardController();

  @override
  void initState() {
    super.initState();

    _demoBoardController.loadFEN(widget.gambit.demoFEN);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.gambit.title),
        backgroundColor: widget.gambit.color,
        centerTitle: true,
        actions: <Widget>[widget.gambit.vector],
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Text(widget.gambit.description),
            SizedBox(height: 20),
            ChessBoard(
              size: MediaQuery.of(context).size.width - 20,
              enableUserMoves: false,
              chessBoardController: _demoBoardController,
              onMove: (move) {},
              onCheckMate: (derp) {},
              onDraw: () {},
            ),
          ],
        ),
      ),
    );
  }
}
