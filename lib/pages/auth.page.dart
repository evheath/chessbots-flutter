import 'package:chessbotsmobile/shared/chess_board.dart';
import 'package:flutter/material.dart';
import '../bloc/auth.bloc.dart';
import '../bloc/base.bloc.dart';
import '../bloc/game_controller.bloc.dart';

class AuthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthBloc _authBloc = BlocProvider.of<AuthBloc>(context);
    return Scaffold(
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
                      : ChessBoard(
                          enableUserMoves: false,
                          onDraw: () {},
                          onMove: (move) {},
                          chessBoardController:
                              GameControllerBloc(playRandom: true),
                          size: MediaQuery.of(context).size.width - 20,
                        );
                }),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                MaterialButton(
                  onPressed: () =>
                      _authBloc.event.add(SignInAnonymouslyEvent()),
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
          ],
        ),
      ),
    );
  }
}
