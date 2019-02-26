import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../shared/chess_board.dart';
import '../shared/left.drawer.dart';
import '../shared/status_list_tile.dart';
import '../shared/gambits.dart';

import '../bloc/base.bloc.dart';
import '../bloc/gambits.bloc.dart';
import '../models/gambit.dart';

class MatchPage extends StatefulWidget {
  final GambitsBloc whiteBot;
  final GambitsBloc blackBot;

  MatchPage({@required this.whiteBot, @required this.blackBot});
  @override
  MatchPageState createState() {
    return MatchPageState();
  }
}

class MatchPageState extends State<MatchPage> {
  ChessBoardController _matchBoardController = ChessBoardController();
  Gambit _lastGambitUsed = EmptyGambit();

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
            //TODO statuslist tile should be handed a bot,
            //bots will also need a stream for last gambit used for the status to listen to
            StatusListTile(gambit: _lastGambitUsed),
            ChessBoard(
              size: MediaQuery.of(context).size.width - 20,
              enableUserMoves: false,
              chessBoardController: _matchBoardController,
              onMove: (move) {},
              onCheckMate: (derp) {},
              onDraw: () {},
            ),
            StatusListTile(gambit: _lastGambitUsed),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Row(
          children: [
            Icon(FontAwesomeIcons.dice),
            SizedBox(width: 10.0),
            Text("Match"),
          ],
        ),
      ),
      drawer: LeftDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _beginMatch();
        },
        tooltip: 'Begin',
        child: Icon(Icons.play_arrow),
      ),
    );
  } // Build

  void _beginMatch() {
    print("we are starting");
  }
}
