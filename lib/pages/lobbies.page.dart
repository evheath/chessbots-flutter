import 'package:chessbotsmobile/bloc/lobbies.bloc.dart';
import 'package:chessbotsmobile/models/lobby.doc.dart';
import 'package:chessbotsmobile/pages/lobby.page.dart';
import 'package:chessbotsmobile/shared/nerd_point_action_display.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chessbotsmobile/services/toaster.service.dart';

class LobbiesPage extends StatefulWidget {
  final DocumentReference botRef;
  const LobbiesPage(this.botRef);

  @override
  _LobbiesPageState createState() => _LobbiesPageState();
}

class _LobbiesPageState extends State<LobbiesPage> {
  final LobbiesBloc _lobbiesBloc = LobbiesBloc();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        centerTitle: true,
        title: Text("Multiplayer"),
        actions: [NerdPointActionDisplay()],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RaisedButton(
                      child: Text("Create a lobby"),
                      onPressed: () {
                        _lobbiesBloc
                            .attemptCreateLobby(widget.botRef)
                            .then((DocumentReference newLobbyRef) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LobbyPage(newLobbyRef)),
                          );
                        }).catchError((e) {
                          handleError(e, context);
                        });
                      },
                    ),
                    // FlatButton.icon(
                    //   label: Text("Search"),
                    //   icon: Icon(FontAwesomeIcons.search),
                    //   onPressed: () {
                    //     //TODO
                    //   },
                    // ),
                  ]),
            ),
            SliverToBoxAdapter(child: Text("Lobbies:")),
            StreamBuilder<List<LobbyDoc>>(
              stream: _lobbiesBloc.lobbies$,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return SliverToBoxAdapter(child: CircularProgressIndicator());
                }
                var filteredLobbies = snapshot.data;
                return SliverList(
                  delegate: SliverChildListDelegate(
                      List.generate(filteredLobbies.length, (index) {
                    LobbyDoc _lobby = filteredLobbies[index];
                    return ListTile(
                      onTap: () {
                        _lobbiesBloc
                            .attemptToChallenge(_lobby, widget.botRef)
                            .then((_) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LobbyPage(_lobby.ref),
                            ),
                          );
                        }).catchError((e) {
                          handleError(e, context);
                        });
                      },
                      title: Text(_lobby.host),
                      trailing: _lobby.createdAt == null
                          ? Text("Just now")
                          : Text(_lobby.minutesAgo),
                    );
                  })),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
