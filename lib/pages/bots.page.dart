import 'package:chessbotsmobile/bloc/base.bloc.dart';
import 'package:chessbotsmobile/bloc/firestore.bloc.dart';
import 'package:chessbotsmobile/models/user.doc.dart';
import 'package:chessbotsmobile/shared/chess_bot_list_tile.dart';
import 'package:chessbotsmobile/shared/nerd_point_action_display.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import '../shared/left.drawer.dart';

class BotsPage extends StatefulWidget {
  @override
  BotsPageState createState() {
    return BotsPageState();
  }
}

class BotsPageState extends State<BotsPage> {
  final FirestoreBloc _firestoreBloc = FirestoreBloc();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<UserDoc>(
        stream: _firestoreBloc.userDoc$,
        builder: (context, snap) {
          if (!snap.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final _bots = snap.data.bots;
          return Container(
            padding: EdgeInsets.all(10.0),
            child: ListView.builder(
              itemCount: _bots?.length ?? 0,
              itemBuilder: (context, index) {
                return ChessBotListTile();
              },
            ),
          );
        },
      ),
      appBar: AppBar(
        title: Row(
          children: [
            Icon(FontAwesomeIcons.robot),
            SizedBox(width: 10.0),
            //TODO check this on iphone SE
            Text("Chess Bots"),
          ],
        ),
        actions: <Widget>[
          NerdPointActionDisplay(),
        ],
      ),
      drawer: LeftDrawer(),
    );
  }
}
