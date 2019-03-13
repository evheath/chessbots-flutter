import 'dart:async';
import 'package:chessbotsmobile/bloc/base.bloc.dart';
import 'package:chessbotsmobile/bloc/matchmaking.bloc.dart';
import 'package:chessbotsmobile/shared/nerd_point_action_display.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MultiplayerPage extends StatefulWidget {
  final DocumentReference botRef;
  const MultiplayerPage(this.botRef);

  @override
  _MultiplayerPageState createState() => _MultiplayerPageState();
}

class _MultiplayerPageState extends State<MultiplayerPage> {
  final MatchmakingBloc _matchmakingBloc = MatchmakingBloc();
  final Firestore _db = Firestore.instance;

  Widget build(BuildContext context) {
    //TODO implement or ditch matchmaking bloc
    return BlocProvider<MatchmakingBloc>(
        bloc: _matchmakingBloc,
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomScrollView(
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FlatButton(
                          child: Text("Create a lobby"),
                          onPressed: () => _createLobby(),
                        ),
                        FlatButton.icon(
                          label: Text("Search"),
                          icon: Icon(FontAwesomeIcons.search),
                          onPressed: () {
                            //TODO
                          },
                        ),
                      ]),
                ),
                SliverToBoxAdapter(child: Text("Lobbies:")),
                StreamBuilder<QuerySnapshot>(
                  // stream: _matchmakingBloc.lobbiesSnapshots,
                  stream: _db.collection('lobbies').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError)
                      return SliverToBoxAdapter(
                          child: Text('Error: ${snapshot.error}'));
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return SliverToBoxAdapter(
                            child: CircularProgressIndicator());
                      default:
                        return SliverList(
                          delegate: SliverChildListDelegate(List.generate(
                              snapshot.data.documents.length, (index) {
                            DocumentSnapshot _doc =
                                snapshot.data.documents[index];
                            return ListTile(
                              title: Text(_doc['host']),
                              trailing: _doc['createdAt'] == null
                                  ? Text("Just now")
                                  : Text(
                                      "${DateTime.now().difference(_doc['createdAt']).inMinutes} minutes ago"),
                            );
                          })),
                        );
                    }
                  },
                ),
              ],
            ),
          ),
          appBar: AppBar(
            backgroundColor: Colors.amber,
            centerTitle: true,
            title: Text("Multiplayer"),
            actions: [NerdPointActionDisplay()],
          ),
        ));
  }

  void _createLobby() async {
    await Future.delayed(Duration(seconds: 1), () => print("creating lobby"));
  }
}
