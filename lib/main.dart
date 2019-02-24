import './pages/auth.page.dart';
import 'package:flutter/material.dart';

// pages
import './pages/lab.page.dart';
import './pages/assemble.page.dart';

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
    final AuthBloc _authBloc = BlocProvider.of<AuthBloc>(context);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chess Bots',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: {
          '/': (context) => StreamBuilder(
                stream: _authBloc.user,
                builder: (context, snapshot) {
                  return snapshot.hasData ? AssemblePage() : AuthPage();
                },
              ),
          '/lab': (context) => LabPage(),
          '/assemble': (context) => AssemblePage(),
        });
  }
}
