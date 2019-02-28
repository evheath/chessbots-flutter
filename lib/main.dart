import 'package:flutter/material.dart';
import './pages/lab.page.dart';
import './pages/auth.page.dart';
import './pages/assemble.page.dart';
import './pages/settings.page.dart';
import './pages/match.page.dart';
import './bloc/base.bloc.dart';
import './bloc/chess_bot.bloc.dart';
import './bloc/auth.bloc.dart';

import './shared/gambits.dart';

void main() => runApp(BlocProvider<AuthBloc>(
    bloc: AuthBloc(),
    child: BlocProvider<ChessBot>(
      bloc: ChessBot(botName: "Your bot"),
      child: MyApp(),
    )));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //TODO these should not exist in main
    // they are here until there is a better way to route to the match page
    final ChessBot human = BlocProvider.of<ChessBot>(context);
    final ChessBot levelonecpu = ChessBot(gambits: [
      CaptureRandomPiece(),
      MoveRandomPawn(),
    ], botName: "Level 1 CPU");

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chess Bots',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: {
          '/': (context) => RouteGuard(AssemblePage()),
          '/lab': (context) => RouteGuard(LabPage()),
          '/assemble': (context) => RouteGuard(AssemblePage()),
          '/settings': (context) => RouteGuard(SettingsPage()),
          //TODO singleplayer route should probably have a splash page
          //I am just using the match page for more direct testing
          '/singleplayer': (context) => RouteGuard(MatchPage(
                whiteBot: human,
                blackBot: levelonecpu,
              )),
        });
  }
}

class RouteGuard extends StatelessWidget {
  final Widget _page;

  RouteGuard(this._page);

  @override
  Widget build(BuildContext context) {
    final AuthBloc _authBloc = BlocProvider.of<AuthBloc>(context);
    return StreamBuilder(
      stream: _authBloc.user,
      builder: (context, snapshot) {
        return snapshot.hasData ? _page : AuthPage();
      },
    );
  }
}
