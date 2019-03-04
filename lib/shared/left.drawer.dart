import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../shared/custom.icons.dart';
import 'package:chessbotsmobile/bloc/firestore.bloc.dart';
import '../bloc/base.bloc.dart';

class LeftDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FirestoreBloc _firestoreBloc =
        BlocProvider.of<FirestoreBloc>(context);
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            title: StreamBuilder<Map<String, dynamic>>(
                stream: _firestoreBloc.userDoc,
                builder: (context, snapshot) {
                  String _name;
                  int _nerdPoints;
                  if (!snapshot.hasData) {
                    _name = "Guest";
                    _nerdPoints = 0;
                  } else {
                    _name = snapshot.data['displayName'] ?? "Guest";
                    _nerdPoints = snapshot.data['nerdPoints'] ?? 0;
                  }
                  return Text("$_name $_nerdPoints");
                }),
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.userAlt),
            title: Text('Singleplayer'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/singleplayer');
            },
          ),
          ListTile(
            leading: Icon(MyCustomIcons.beaker),
            title: Text('Lab'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/lab');
            },
          ),
          ListTile(
            leading: Icon(MyCustomIcons.cog_alt),
            title: Text('Assemble gambits'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/assemble');
            },
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.cog),
            title: Text('Settings'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/settings');
            },
          )
        ],
      ),
    );
  }
}
