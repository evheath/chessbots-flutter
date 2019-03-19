import 'package:chessbotsmobile/bloc/lobbies.bloc.dart';
import 'package:chessbotsmobile/models/lobby.doc.dart';
import 'package:chessbotsmobile/pages/lobby.page.dart';
import 'package:chessbotsmobile/shared/nerd_point_action_display.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
                    FlatButton(
                      child: Text("Create a lobby"),
                      onPressed: _createLobby,
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
                    LobbyDoc _doc = filteredLobbies[index];
                    return ListTile(
                      onTap: () {
                        //TODO challenger page
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) =>
                        //         LobbyChallengerPage(_doc.reference),
                        //   ),
                        // );
                      },
                      title: Text(_doc.host),
                      trailing: _doc.createdAt == null
                          ? Text("Just now")
                          : Text(_doc.minutesAgo),
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

  void _createLobby() async {
    //TODO move this into lobbiesBloc
    DocumentReference newLobbyRef =
        Firestore.instance.collection('lobbies').document();

    var snap = await widget.botRef.get();
    String name = snap['name'];

    await newLobbyRef.setData({
      "host": name,
      "hostBot": widget.botRef,
    });

    // print("created lobby");

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LobbyPage(newLobbyRef)),
    );
  }
}
