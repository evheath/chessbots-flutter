import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../shared/custom.icons.dart';
import '../bloc/auth.bloc.dart';
import '../bloc/base.bloc.dart';

class LeftDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthBloc _authBloc = BlocProvider.of<AuthBloc>(context);
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            title: StreamBuilder<FirebaseUser>(
              stream: _authBloc.user,
              builder: (context, snapshot) =>
                  Text(snapshot.data?.displayName ?? "Guest"),
            ),
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
