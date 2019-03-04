import 'package:chessbotsmobile/bloc/prefs.bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../shared/left.drawer.dart';
import 'package:flutter/material.dart';
import '../bloc/auth.bloc.dart';
import '../bloc/base.bloc.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FirestoreBloc _authBloc = BlocProvider.of<FirestoreBloc>(context);
    final PrefsBloc _prefsBloc = BlocProvider.of<PrefsBloc>(context);
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      drawer: LeftDrawer(),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text("Dark Mode"),
            trailing: StreamBuilder<PrefsState>(
                stream: _prefsBloc.prefs,
                initialData: PrefsState(),
                builder: (context, snapshot) {
                  final bool darkTheme = snapshot.data.darkTheme;
                  return Switch(
                    value: darkTheme,
                    onChanged: (b) {
                      _prefsBloc.event.add(ToggleDarkThemeEvent());
                    },
                  );
                }),
          ),
          Divider(),
          StreamBuilder<FirebaseUser>(
              stream: _authBloc.user,
              builder: (context, snapshot) {
                FirebaseUser _user = snapshot.data;
                return ListTile(
                  title: Text("Signed in as ${_user?.displayName ?? 'Guest'}"),
                  subtitle: Text("${_user?.email ?? ''}"),
                  trailing: RaisedButton(
                    child: Text("Signout"),
                    onPressed: () => _authBloc.authEvent.add(SignOutEvent()),
                  ),
                );
              }),
          Divider(),
        ],
      ),
    );
  }
}
