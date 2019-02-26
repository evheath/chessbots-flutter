import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/gambit.dart';
import 'package:flare_flutter/flare_actor.dart';
import '../bloc/auth.bloc.dart';
import '../bloc/base.bloc.dart';

class StatusListTile extends StatelessWidget {
  final Gambit gambit;

  StatusListTile({@required this.gambit});

  @override
  Widget build(BuildContext context) {
    final AuthBloc _authBloc = BlocProvider.of<AuthBloc>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
            // border: Border.all(),
            // borderRadius: BorderRadius.circular(5.0),
            // color: gambit.color.withAlpha(75),
            ),
        child: ListTile(
          leading: StreamBuilder<FirebaseUser>(
            stream: _authBloc.user,
            builder: (context, snapshot) =>
                Text(snapshot.data?.displayName ?? "Guest"),
          ),
          title: SizedBox(
            height: 75,
            child: FlareActor(
              'animations/chessbot.flr',
              animation: 'idle',
            ),
          ),
          trailing: CircleAvatar(
            child: Icon(gambit.icon, color: Colors.white),
            backgroundColor: gambit.color,
          ),
        ),
      ),
    );
  }
}
