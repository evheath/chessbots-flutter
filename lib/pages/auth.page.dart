import 'package:chessbotsmobile/bloc/firestore.bloc.dart';
import 'package:chessbotsmobile/shared/chess_board.dart';
import 'package:flutter/material.dart';
import '../bloc/base.bloc.dart';
import '../bloc/game_controller.bloc.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  GameControllerBloc _demoController = GameControllerBloc(playRandom: true);
  @override
  Widget build(BuildContext context) {
    final FirestoreBloc _firestoreBloc =
        BlocProvider.of<FirestoreBloc>(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            StreamBuilder<bool>(
                stream: _firestoreBloc.loading,
                initialData: false,
                builder: (context, snapshot) {
                  return snapshot.data
                      ? CircularProgressIndicator()
                      : ChessBoard(
                          enableUserMoves: false,
                          onDraw: () {},
                          onMove: (move) {},
                          chessBoardController: _demoController,
                          size: MediaQuery.of(context).size.width - 20,
                        );
                }),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                MaterialButton(
                  onPressed: () {
                    // _firestoreBloc.authEvent.add(SignInAnonymouslyEvent()),
                    _warnGuest();
                  },
                  color: Colors.white,
                  textColor: Colors.black,
                  child: Text('Login as guest'),
                ),
                MaterialButton(
                  onPressed: () =>
                      _firestoreBloc.authEvent.add(SignInWithGoogleEvent()),
                  color: Colors.red,
                  textColor: Colors.black,
                  child: Text(
                    'Login with Google',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _warnGuest() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final FirestoreBloc _firestoreBloc =
            BlocProvider.of<FirestoreBloc>(context);
        return AlertDialog(
          title: Text("Caution"),
          content: Text("Guest accounts are lost after signout!"),
          actions: <Widget>[
            FlatButton(
              child: Text("Back"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("Okay"),
              onPressed: () {
                Navigator.of(context).pop();
                _firestoreBloc.authEvent.add(SignInAnonymouslyEvent());
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _demoController.dispose();
    super.dispose();
  }
}
