import 'package:flutter/material.dart';
import '../bloc/auth.bloc.dart';
import '../bloc/base.bloc.dart';

class AuthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthBloc _authBloc = BlocProvider.of<AuthBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign in"),
        backgroundColor: Colors.amber,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            MaterialButton(
              onPressed: () => _authBloc.event.add(SignInAnonymouslyEvent()),
              color: Colors.white,
              textColor: Colors.black,
              child: Text('Login as guest'),
            ),
            MaterialButton(
              onPressed: () => _authBloc.event.add(SignInWithGoogleEvent()),
              color: Colors.red,
              textColor: Colors.black,
              child: Text('Login with Google'),
            ),
          ],
        ),
      ),
    );
  }
}
