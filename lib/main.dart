import 'package:chessbotsmobile/bloc/prefs.bloc.dart';
import 'package:chessbotsmobile/pages/bots.page.dart';
import 'package:chessbotsmobile/pages/singleplayer.page.dart';
import 'package:flutter/material.dart';
import './pages/lab.page.dart';
import './pages/auth.page.dart';
import './pages/settings.page.dart';
import './bloc/base.bloc.dart';
import './bloc/chess_bot.bloc.dart';
import 'package:chessbotsmobile/bloc/firestore.bloc.dart';
import 'package:flutter/services.dart';

void main() async {
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final FirestoreBloc _firestoreBloc = FirestoreBloc();
  final PrefsBloc _prefsBloc = PrefsBloc();
  final ChessBot _chessBot = ChessBot(name: "Default Bot");

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FirestoreBloc>(
      bloc: _firestoreBloc,
      child: BlocProvider<PrefsBloc>(
        bloc: _prefsBloc,
        child: BlocProvider<ChessBot>(
          bloc: _chessBot,
          child: StreamBuilder<PrefsState>(
              stream: _prefsBloc.prefs,
              builder: (context, snapshot) {
                return snapshot.hasData
                    ? MaterialApp(
                        debugShowCheckedModeBanner: false,
                        title: 'Chess Bots',
                        theme: ThemeData(
                          primarySwatch: Colors.blue,
                          brightness: snapshot.data.darkTheme
                              ? Brightness.dark
                              : Brightness.light,
                        ),
                        routes: {
                            '/': (context) => RouteGuard(SingleplayerPage()),
                            '/lab': (context) => RouteGuard(LabPage()),
                            '/settings': (context) =>
                                RouteGuard(SettingsPage()),
                            '/singleplayer': (context) =>
                                RouteGuard(SingleplayerPage()),
                            '/bots': (context) => RouteGuard(BotsPage()),
                          })
                    : Container(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ); //protecting user from not having their settings
              }),
        ),
      ),
    );
  }
}

class RouteGuard extends StatelessWidget {
  final Widget _page;

  RouteGuard(this._page);

  @override
  Widget build(BuildContext context) {
    final FirestoreBloc _firestoreBloc =
        BlocProvider.of<FirestoreBloc>(context);
    return StreamBuilder(
      stream: _firestoreBloc.user,
      builder: (context, snapshot) {
        return snapshot.hasData ? _page : AuthPage();
      },
    );
  }
}
