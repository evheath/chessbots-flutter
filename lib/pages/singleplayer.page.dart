import 'package:chessbotsmobile/models/chess_bot.dart';
import 'package:chessbotsmobile/bloc/firestore.bloc.dart';
import 'package:chessbotsmobile/pages/bots.page.dart';
import 'package:chessbotsmobile/pages/match.page.dart';
import 'package:chessbotsmobile/shared/left.drawer.dart';
import 'package:chessbotsmobile/shared/nerd_point_action_display.dart';
import 'package:chessbotsmobile/shared/opponent_list_tile.dart';
import 'package:chessbotsmobile/shared/prebuilt_bots.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';

class SingleplayerPage extends StatefulWidget {
  @override
  SingleplayerPageState createState() {
    return SingleplayerPageState();
  }
}

class SingleplayerPageState extends State<SingleplayerPage> {
  @override
  void initState() {
    super.initState();
  }

  List<Widget> _buildOpponentListTiles(BuildContext context) {
    final List<ChessBot> _opponentBots = [
      levelZeroCPU,
      levelOneCPU,
      levelTwoCPU
    ];

    return List.generate(
      _opponentBots.length,
      (index) {
        return GestureDetector(
          onTap: () => presentSelectBotDialog(context, _opponentBots[index]),
          child: Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: OpponentListTile(_opponentBots[index]),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: ListView(
          children: _buildOpponentListTiles(context),
        ),
      ),
      appBar: AppBar(
        leading: Builder(builder: (context) {
          return IconButton(
            icon: const Icon(FontAwesomeIcons.userAlt),
            onPressed: () => Scaffold.of(context).openDrawer(),
          );
        }),
        centerTitle: true,
        title: Text("Singleplayer"),
        actions: [NerdPointActionDisplay()],
      ),
      drawer: LeftDrawer(),
    );
  }

  void presentSelectBotDialog(
      BuildContext context, ChessBot _selectedOpponent) async {
    final _currentUserData = await FirestoreBloc().userDoc$.first;
    final _botrefs = _currentUserData.bots;
    showDialog(
        context: context,
        builder: (context) => SimpleDialog(
              title: Text("Select your bot"),
              children: List.generate(_botrefs.length, (index) {
                return _buildSelectListTile(_botrefs[index], _selectedOpponent);
              })
                ..add(ListTile(
                    leading: Icon(Icons.add),
                    title: Text("Create a new bot"),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => BotsPage()));
                    })),
            ));
  }

  Widget _buildSelectListTile(
      DocumentReference _ref, ChessBot _selectedOpponent) {
    return StreamBuilder<ChessBot>(
      stream: marshalChessBot(_ref),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return ListTile(
            leading: CircularProgressIndicator(),
          );
        } else {
          ChessBot _playerBot = snapshot.data;
          return ListTile(
            title: Text("${_playerBot.name}"),
            onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => MatchPage(
                          blackBot: _selectedOpponent,
                          whiteBot: _playerBot,
                        ))),
          );
        }
      },
    );
  }
}
