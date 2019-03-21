import 'package:chessbotsmobile/models/chess_bot.dart';
import 'package:chessbotsmobile/pages/singleplayer_match.page.dart';
import 'package:chessbotsmobile/shared/nerd_point_action_display.dart';
import 'package:chessbotsmobile/shared/opponent_list_tile.dart';
import 'package:chessbotsmobile/shared/prebuilt_bots.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SingleplayerPage extends StatelessWidget {
  final DocumentReference botRef;
  const SingleplayerPage(this.botRef);
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<ChessBot>(
          stream: marshalChessBot(botRef),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              ChessBot _chessBot = snapshot.data;
              return Container(
                padding: EdgeInsets.all(10.0),
                child: ListView(
                    children: _buildOpponentListTiles(context, _chessBot)),
              );
            }
          }),
      appBar: AppBar(
        backgroundColor: Colors.teal,
        // leading: Builder(builder: (context) {
        //   return IconButton(
        //     icon: const Icon(FontAwesomeIcons.userAlt),
        //     onPressed: () => Scaffold.of(context).openDrawer(),
        //   );
        // }),
        centerTitle: true,
        title: Text("Singleplayer"),
        actions: [NerdPointActionDisplay()],
      ),
      // drawer: LeftDrawer(),
    );
  }

  List<Widget> _buildOpponentListTiles(
      BuildContext context, ChessBot _playerBot) {
    final List<ChessBot> _opponentBots = [
      oscarCPU,
      garrettCPU,
      peterCPU,
      rickCPU,
      carlosCPU,
    ];
    //sort by lowest to highest bounty
    _opponentBots.sort((a, b) => a.bounty.compareTo(b.bounty));

    return List.generate(
      _opponentBots.length,
      (index) {
        return GestureDetector(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SingleplayerMatchPage(
                        opponentBot: _opponentBots[index],
                        playerBot: _playerBot,
                      ))),
          child: Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: OpponentListTile(_opponentBots[index]),
          ),
        );
      },
    );
  }
}
