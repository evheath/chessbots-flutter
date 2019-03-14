import 'package:chessbotsmobile/bloc/base.bloc.dart';
// import 'package:chessbotsmobile/pages/lobby_challenger.page.dart';
import 'package:chessbotsmobile/pages/lobby_host.page.dart';
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
  final Firestore _db = Firestore.instance;

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
            StreamBuilder<QuerySnapshot>(
              stream: _db
                  .collection('lobbies')
                  // .where("challengerBot", isNull: true) // doesn't seem to filter properly
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return SliverToBoxAdapter(child: CircularProgressIndicator());
                }
                List<DocumentSnapshot> filteredLobbies = snapshot.data.documents
                    .where((snap) => snap["challengerBot"] == null)
                    .toList();
                return SliverList(
                  delegate: SliverChildListDelegate(
                      List.generate(filteredLobbies.length, (index) {
                    DocumentSnapshot _doc = filteredLobbies[index];
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
                      title: Text(_doc['host']),
                      trailing: _doc['createdAt'] == null
                          ? Text("Just now")
                          : Text(
                              "${DateTime.now().difference(_doc['createdAt']).inMinutes} minutes ago"),
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
    DocumentReference newLobbyRef = _db.collection('lobbies').document();

    var snap = await widget.botRef.get();
    String name = snap['name'];

    await newLobbyRef.setData({
      "host": name,
      "hostBot": widget.botRef,
    });

    // print("created lobby");

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LobbyHostPage(newLobbyRef),
        // fullscreenDialog: true,
      ),
    );
  }
}
