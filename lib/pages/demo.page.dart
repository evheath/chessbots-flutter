import 'package:flutter/material.dart';
import '../models/gambit.dart';
import '../shared/chess_board.dart';
import '../bloc/game_controller.bloc.dart';

class DemoPage extends StatefulWidget {
  final Gambit gambit;
  DemoPage(this.gambit);

  @override
  DemoPageState createState() {
    return new DemoPageState();
  }
}

class DemoPageState extends State<DemoPage> {
  GameControllerBloc _demoBoardController = GameControllerBloc();
  bool _hasNotMoved = true;

  @override
  void dispose() {
    _demoBoardController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _demoBoardController.loadFEN(widget.gambit.demoFEN);
  }

  Widget _buildText() {
    if (_hasNotMoved) {
      return Text(
        widget.gambit.description,
      );
    } else {
      return Text(
        widget.gambit.altText,
      );
    }
  }

  Widget _buildPlayButton() {
    if (_hasNotMoved) {
      // button has not been pressed yet
      return RaisedButton(
        onPressed: () {
          String move = widget.gambit.findMove(_demoBoardController.game);
          _demoBoardController.makeMove(move);
          setState(() {
            _hasNotMoved = false;
          });
        },
        child: Icon(
          Icons.play_arrow,
          color: Colors.white,
        ),
        color: widget.gambit.color,
      );
    } else {
      return RaisedButton(
        onPressed: () {
          _demoBoardController.loadFEN(widget.gambit.demoFEN);
          setState(() {
            _hasNotMoved = true;
          });
        },
        child: Icon(
          Icons.fast_rewind,
          color: Colors.white,
        ),
        color: widget.gambit.color,
      );
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.gambit.title),
        backgroundColor: widget.gambit.color,
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Container(
              child: Center(child: _buildText()),
              height: 20,
            ),
            SizedBox(height: 20),
            ChessBoard(
              size: MediaQuery.of(context).size.width - 20,
              enableUserMoves: false,
              chessBoardController: _demoBoardController,
              onMove: (move) {},
              onCheckMate: (derp) {},
              onDraw: () {},
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Hero(
                    tag: widget.gambit.title,
                    child: CircleAvatar(
                      radius: 35,
                      child: Icon(
                        widget.gambit.icon,
                        color: Colors.white,
                        size: 50,
                      ),
                      backgroundColor: widget.gambit.color,
                    )),
                _buildPlayButton(),
              ],
            )
            //TODO buy button if gambit is not owned
          ],
        ),
      ),
    );
  }
}
