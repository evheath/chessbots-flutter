import 'package:flutter/material.dart';

// import '../bloc/base.bloc.dart';
// import '../bloc/lab.bloc.dart';

// import '../shared/chess_board.dart';
import '../shared/left.drawer.dart';
import '../shared/custom.icons.dart';

// import 'package:chess/chess.dart' as chess;
import './lab.bloc.dart';

class LabPage extends StatefulWidget {
  @override
  LabPageState createState() {
    return LabPageState();
  }
}

class LabPageState extends State<LabPage> {
  final LabBloc labBloc = LabBloc();
  // chess.Chess game;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final LabBloc bloc = BlocProvider.of<LabBloc>(context);
    return Scaffold(
      // body: Text('Hello world'),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            StreamBuilder<String>(
              stream: labBloc.fen,
              // initialData: "initialData",
              builder: (context, snapshot) {
                return Text(snapshot.data);
                // return Text('derp');
              },
            ),
            // Text('Sample'),
            //
            // StreamBuilder<bool>(
            //   stream: bloc.whiteOnBottom,
            //   initialData: true,
            //   builder: (context, snapshot) {
            //     print('stream builder ran');
            //     return ChessBoard(
            //       onMove: (move) {},
            //       onCheckMate: (color) {
            //         print(color);
            //       },
            //       onDraw: () {},
            //       size: MediaQuery.of(context).size.width - 20,
            //       enableUserMoves: true,
            //       chessBoardController: controller,
            //       whiteSideTowardsUser: snapshot.data,
            //     );
            //   },
            // ),
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
            onPressed: () {
              labBloc.randomMove();
            },
            tooltip: 'Test gambits',
            child: Icon(Icons.play_arrow),
          ),
          // FloatingActionButton(
          //   onPressed: () {},
          //   tooltip: 'Swap',
          //   child: Icon(Icons.shuffle),
          // ),
          // FloatingActionButton(
          //   onPressed: () {},
          //   tooltip: 'Reset',
          //   child: Icon(Icons.repeat),
          // ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  } // Build

}
