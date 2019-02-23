/// Page for reordering gambits, similar to right-hand pane in web-app

import 'package:flutter/material.dart';
import '../shared/left.drawer.dart';
import '../shared/custom.icons.dart';
import '../bloc/base.bloc.dart';
import '../bloc/gambits.bloc.dart';
import '../models/gambit.dart';
import '../shared/gambits.dart';
import '../shared/gambit_list_tile.dart';

class AssemblePage extends StatefulWidget {
  @override
  AssemblePageState createState() {
    return AssemblePageState();
  }
}

class AssemblePageState extends State<AssemblePage> {
  @override
  Widget build(BuildContext context) {
    final GambitsBloc gambitsBloc = BlocProvider.of<GambitsBloc>(context);
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: StreamBuilder(
          initialData: [MoveRandomPiece()], // need for error prevention
          stream: gambitsBloc.gambits,
          builder: (context, snapshot) {
            List<Gambit> _gambits = snapshot.data;
            return ReorderableListView(
              scrollDirection: Axis.vertical,
              onReorder: (oldIndex, newIndex) {
                gambitsBloc.event.add(ReorderEvent(oldIndex, newIndex));
              },
              header: GambitListTile(gambit: CheckmateOpponent()),
              children: _buildGambitListTiles(_gambits, gambitsBloc),
            );
          },
        ),
      ),
      appBar: AppBar(
        title: Row(
          children: [
            Icon(MyCustomIcons.cog_alt),
            SizedBox(width: 10.0),
            Text("Assemble your gambits"),
          ],
        ),
      ),
      drawer: LeftDrawer(),
    );
  } // Build

  List<Widget> _buildGambitListTiles(
      List<Gambit> _gambits, GambitsBloc gambitsBloc) {
    //configurable gambits first
    List<Widget> _gambitTiles = List.generate(_gambits.length, (index) {
      return Dismissible(
        resizeDuration: Duration(microseconds: 1),
        direction: DismissDirection.horizontal,
        key: Key(_gambits[index].title),
        child: GambitListTile(
          //TODO swiping should dismiss the gambit, and leave an open gambit
          gambit: _gambits[index],
        ),
        onDismissed: (direction) {
          gambitsBloc.event.add(DismissedEvent(index));
        },
      );
    });

    // gambits that are always added to the end
    // eg MoveRandomPiece(), EmptyGambit(), LevelUpGambit(),
    _gambitTiles.add(GambitListTile(
      gambit: MoveRandomPiece(),
      key: Key(MoveRandomPiece().title),
    ));

    return _gambitTiles;
  }
}
