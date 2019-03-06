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
  List<DocumentReference> _bots;
  final FirestoreBloc _firestoreBloc = FirestoreBloc();

  @override
  void initState() {
    _getBots();
    super.initState();
  }

  void _getBots() async {
    UserDoc _currentUserData = await _firestoreBloc.userDoc$.first;
    _bots = _currentUserData.bots;
    print("bots is $_bots");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: ListView(
          children: <Widget>[
            ChessBotListTile(),
          ],
        ),
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
