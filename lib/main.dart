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
  runApp(
    BlocProvider<AuthBloc>(
      bloc: AuthBloc(),
      child: BlocProvider<PrefsBloc>(
        bloc: PrefsBloc(),
        child: BlocProvider<ChessBot>(
          bloc: ChessBot(botName: "Your bot"),
          child: MyApp(),
        ),
      ),
    ),
  );
}

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

    final PrefsBloc _prefsBloc = BlocProvider.of<PrefsBloc>(context);
    return StreamBuilder<PrefsState>(
        stream: _prefsBloc.prefs,
        initialData: PrefsState(),
        builder: (context, snapshot) {
          PrefsState _prefs = snapshot.data;
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Chess Bots',
              theme: ThemeData(
                primarySwatch: Colors.blue,
                brightness:
                    _prefs.darkTheme ? Brightness.dark : Brightness.light,
              ),
              routes: {
                // '/': (context) => RouteGuard(MatchPage(
                //       whiteBot: human,
                //       blackBot: levelonecpu,
                //     )),
                '/': (context) => RouteGuard(SettingsPage()),
                // '/': (context) => RouteGuard(AssemblePage()),
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
