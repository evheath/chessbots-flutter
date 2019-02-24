import '../shared/left.drawer.dart';
import 'package:flutter/material.dart';
import '../bloc/auth.bloc.dart';
import '../bloc/base.bloc.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthBloc _authBloc = BlocProvider.of<AuthBloc>(context);
    return Scaffold(
      appBar: AppBar(title: Text("Settings Page")),
      drawer: LeftDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
