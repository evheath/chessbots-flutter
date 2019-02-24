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
      //TODO make auth page presentable, maybe email/password login too
      body: Center(
        child: Column(
          children: <Widget>[
            MaterialButton(
              onPressed: () => _authBloc.event.add(SignInAnonymouslyEvent()),
              color: Colors.white,
              textColor: Colors.black,
              child: Text('Login as guest'),
            ),
            MaterialButton(
              onPressed: () => _authBloc.event.add(SignInWithGoogleEvent()),
              color: Colors.white,
              textColor: Colors.black,
              child: Text('Login with Google'),
            ),
            StreamBuilder(
                stream: _authBloc.user,
                builder: (context, snapshot) {
                  return Text(
                      'User data (should not be seen) ${snapshot.data}');
                }),
          ],
        ),
      ),
    );
  }
}
