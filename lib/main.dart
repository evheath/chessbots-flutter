import 'package:chessbotsmobile/bloc/prefs.bloc.dart';
import 'package:flutter/material.dart';
import './pages/lab.page.dart';
import './pages/auth.page.dart';
import './pages/assemble.page.dart';
import './pages/settings.page.dart';
import './pages/match.page.dart';
import './bloc/base.bloc.dart';
import './bloc/chess_bot.bloc.dart';
import './bloc/auth.bloc.dart';
import 'package:flutter/services.dart';
import './shared/gambits.dart';

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
  final ChessBot _chessBot = ChessBot(botName: "Your bot");
  // TODO prebuilt chess bots should not exist in main
  final ChessBot levelonecpu = ChessBot(gambits: [
    CaptureRandomPiece(),
    MoveRandomPawn(),
  ], botName: "Level 1 CPU");

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
                            '/': (context) => RouteGuard(MatchPage(
                                  whiteBot: _chessBot,
                                  blackBot: levelonecpu,
                                )),
                            // '/': (context) => RouteGuard(SettingsPage()),
                            // '/': (context) => RouteGuard(AssemblePage()),
                            '/lab': (context) => RouteGuard(LabPage()),
                            '/assemble': (context) =>
                                RouteGuard(AssemblePage()),
                            '/settings': (context) =>
                                RouteGuard(SettingsPage()),
                            //TODO singleplayer route should probably have a splash page
                            //I am just using the match page for more direct testing
                            '/singleplayer': (context) => RouteGuard(MatchPage(
                                  whiteBot: _chessBot,
                                  blackBot: levelonecpu,
                                )),
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
