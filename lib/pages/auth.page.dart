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
            StreamBuilder<bool>(
              stream: _authBloc.loading,
              initialData: false,
              builder: (context, snapshot) {
                return snapshot.data
                    ? CircularProgressIndicator()
                    : Container();
              },
            ),
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
              child: Text(
                'Login with Google',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
