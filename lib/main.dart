import 'package:flutter/material.dart';

// pages
import './pages/lab.page.dart';
import './pages/assemble.page.dart';

// import './bloc/base.bloc.dart';
// import './bloc/lab.bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // home: BlocProvider<LabBloc>(
        //   bloc: LabBloc(),
        //   child: LabPage(),
        // ),
        routes: {
          '/': (context) => AssemblePage(),
          '/lab': (context) => LabPage(),
          '/assemble': (context) => AssemblePage(),
        });
  }
}
