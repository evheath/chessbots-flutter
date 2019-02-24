import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../bloc/auth.bloc.dart';
import '../bloc/base.bloc.dart';

class AuthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthBloc _authBloc = BlocProvider.of<AuthBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Auth Page"),
        backgroundColor: Colors.amber,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            StreamBuilder<FirebaseUser>(
                stream: _authBloc.user,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return MaterialButton(
                      onPressed: () => _authBloc.signOut(),
                      color: Colors.red,
                      textColor: Colors.white,
                      child: Text('Signout'),
                    );
                  } else {
                    return MaterialButton(
                      onPressed: () => _authBloc.googleSignIn(),
                      color: Colors.white,
                      textColor: Colors.black,
                      child: Text('Login with Google'),
                    );
                  }
                }),
            // LoginButton(), // <-- Built with StreamBuilder
            StreamBuilder<Map<String, dynamic>>(
                stream: _authBloc.profile,
                builder: (context, snapshot) {
                  Map<String, dynamic> _profile = snapshot.data;
                  return Container(
                    padding: EdgeInsets.all(20),
                    child: Text("Bloc profile: $_profile"),
                  );
                }),
            // UserProfile(), // <-- Built with StatefulWidget
          ],
        ),
      ),
    );
  }
}
