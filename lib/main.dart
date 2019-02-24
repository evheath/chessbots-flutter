import 'package:flutter/material.dart';
import './pages/lab.page.dart';
import './pages/auth.page.dart';
import './pages/assemble.page.dart';
import './pages/settings.page.dart';
import './bloc/base.bloc.dart';
import './bloc/gambits.bloc.dart';
import './bloc/auth.bloc.dart';

void main() => runApp(BlocProvider<AuthBloc>(
    bloc: AuthBloc(),
    child: BlocProvider<GambitsBloc>(
      bloc: GambitsBloc(),
      child: MyApp(),
    )));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
