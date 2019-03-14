import 'dart:async';

import 'package:chessbotsmobile/bloc/prefs.bloc.dart';
import 'package:chessbotsmobile/pages/bots.page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crashlytics/flutter_crashlytics.dart';
import './pages/auth.page.dart';
import './pages/settings.page.dart';
import './bloc/base.bloc.dart';
import 'package:chessbotsmobile/bloc/firestore.bloc.dart';
import 'package:flutter/services.dart';

void main() async {
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  // runApp(MyApp());
  bool isInDebugMode = false;

  FlutterError.onError = (FlutterErrorDetails details) {
    if (isInDebugMode) {
      // In development mode simply print to console.
      FlutterError.dumpErrorToConsole(details);
    } else {
      // In production mode report to the application zone to report to
      // Crashlytics.
      Zone.current.handleUncaughtError(details.exception, details.stack);
    }
  };

  await FlutterCrashlytics().initialize();

  runZoned<Future<Null>>(() async {
    runApp(MyApp());
  }, onError: (error, stackTrace) async {
    // Whenever an error occurs, call the `reportCrash` function. This will send
    // Dart errors to our dev console or Crashlytics depending on the environment.
    await FlutterCrashlytics().reportCrash(error, stackTrace, forceCrash: true);
  });
}

class MyApp extends StatelessWidget {
  final FirestoreBloc _firestoreBloc = FirestoreBloc();
  final PrefsBloc _prefsBloc = PrefsBloc();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FirestoreBloc>(
      bloc: _firestoreBloc,
      child: BlocProvider<PrefsBloc>(
        bloc: _prefsBloc,
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
                          '/': (context) => RouteGuard(BotsPage()),
                          '/home': (context) => RouteGuard(BotsPage()),
                          '/bots': (context) => RouteGuard(BotsPage()),
                          '/settings': (context) => RouteGuard(SettingsPage()),
                        })
                  : Container(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ); //protecting user from not having their settings
            }),
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
