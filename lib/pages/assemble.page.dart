import 'package:chessbotsmobile/shared/level_up_list.dart';
import 'package:chessbotsmobile/shared/nerd_point_action_display.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import './assemble.tutorial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../shared/empty_list_tile.dart';
import 'package:flutter/material.dart';
import '../shared/left.drawer.dart';
import '../shared/custom.icons.dart';
import '../bloc/base.bloc.dart';
import '../bloc/chess_bot.bloc.dart';
import '../models/gambit.dart';
import '../shared/gambits.dart';
import '../shared/gambit_list_tile.dart';
import '../pages/select_gambit.page.dart';

class AssemblePage extends StatefulWidget {
  @override
  AssemblePageState createState() {
    return AssemblePageState();
  }
}

class AssemblePageState extends State<AssemblePage> {
  @override
  void initState() {
    _checkIfNeverSeenTutorial();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ChessBot _chessBot = BlocProvider.of<ChessBot>(context);
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: StreamBuilder(
          initialData: [MoveRandomPiece()], // need for error prevention
          stream: _chessBot.gambits,
          builder: (context, snapshot) {
            List<Gambit> _gambits = snapshot.data;
            return ReorderableListView(
              scrollDirection: Axis.vertical,
              onReorder: (oldIndex, newIndex) {
                _chessBot.event.add(ReorderEvent(oldIndex, newIndex));
              },
              header: GambitListTile(gambit: CheckmateOpponent()),
              children: _buildGambitListTiles(_gambits, _chessBot),
            );
          },
        ),
      ),
      appBar: AppBar(
        title: Row(
          children: [
            Icon(MyCustomIcons.cog_alt),
            SizedBox(width: 10.0),
            Text("Build your bot"),
          ],
        ),
        actions: <Widget>[
          // IconButton(
          //   tooltip: "Tutorial",
          //   icon: Icon(FontAwesomeIcons.questionCircle),
          //   onPressed: () {
          //// TODO move tutorial to a 'help' page
          //     _showTutorial();
          //   },
          // ),
          NerdPointActionDisplay(),
        ],
      ),
      drawer: LeftDrawer(),
    );
  } // Build

  void _showTutorial() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AssembleTutorial(),
        fullscreenDialog: true,
      ),
    ).then((_) async {
      // marking the tutorial as seen
      final SharedPreferences _prefsInstance =
          await SharedPreferences.getInstance();
      _prefsInstance.setBool("seenAssembleTutorial", true);
    });
  }

  Future<void> _checkIfNeverSeenTutorial() async {
    //TODO is there a way to do this in bloc?
    final SharedPreferences _prefsInstance =
        await SharedPreferences.getInstance();
    final seenAssembleTutorial =
        _prefsInstance.getBool('seenAssembleTutorial') ?? false;
    if (!seenAssembleTutorial) {
      _showTutorial();
    }
  }

  List<Widget> _buildGambitListTiles(
      List<Gambit> _gambits, ChessBot _chessBot) {
    //configurable gambits first
    List<Widget> _gambitTiles = List.generate(_gambits.length, (index) {
      Gambit _gambit = _gambits[index];
      return _gambit == EmptyGambit()
          ? GestureDetector(
              // if the gambit is empty
              key: Key(_gambit.title),
              child: EmptyListTile(),
              onTap: () {
                Navigator.push<Gambit>(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SelectGambitPage()))
                    .then((Gambit selectedGambit) {
                  if (selectedGambit != null) {
                    _chessBot.event
                        .add(SelectGambitEvent(index, selectedGambit));
                  }
                });
              },
            )
          : Dismissible(
              // if it is a regular gambit
              resizeDuration: Duration(microseconds: 1),
              direction: DismissDirection.horizontal,
              key: Key(_gambit.title),
              child: GambitListTile(
                gambit: _gambit,
              ),
              onDismissed: (direction) {
                // swiping a list tile will replace it with an empty gambit
                _chessBot.event.add(DismissedEvent(index));
              },
              background: EmptyListTile(),
            );
    });

    // gambits that are always added to the end
    _gambitTiles.addAll([
      GestureDetector(
        key: Key("Level up"),
        child: LevelUpTile(),
        onTap: () {
          print("level up suckaa!");
          _levelUpPrompt();
        },
      ),
      GambitListTile(
        gambit: MoveRandomPiece(),
        key: Key(MoveRandomPiece().title),
      ),
    ]);

    return _gambitTiles;
  }

  void _levelUpPrompt() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Level Up?"),
          content: Text("Spend nerd points to unlock a new gambit slot?"),
          actions: <Widget>[
            FlatButton(
              child: Text("Nah"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
