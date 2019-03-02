import 'package:chessbotsmobile/bloc/prefs.bloc.dart';

import '../shared/left.drawer.dart';
import 'package:flutter/material.dart';
import '../bloc/auth.bloc.dart';
import '../bloc/base.bloc.dart';

//TODO dark theme
class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthBloc _authBloc = BlocProvider.of<AuthBloc>(context);
    final PrefsBloc _prefsBloc = BlocProvider.of<PrefsBloc>(context);
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      drawer: LeftDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            StreamBuilder<PrefsState>(
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
            MaterialButton(
              onPressed: () => _authBloc.event.add(SignOutEvent()),
              color: Colors.white,
              textColor: Colors.black,
              child: Text('Signout'),
            ),
          ],
        ),
      ),
    );
  }
}
