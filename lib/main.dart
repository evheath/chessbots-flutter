import 'package:flutter/material.dart';

// pages
import './pages/lab.page.dart';
import './pages/assemble.page.dart';

import './bloc/base.bloc.dart';
import './bloc/gambits.bloc.dart';

void main() => runApp(BlocProvider<GambitsBloc>(
      bloc: GambitsBloc(),
      child: MyApp(),
    ));

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
          '/': (context) => AssemblePage(),
          '/lab': (context) => LabPage(),
          '/assemble': (context) => AssemblePage(),
        });
  }
}
