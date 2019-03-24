import 'package:chessbotsmobile/bloc/base.bloc.dart';
import 'package:chessbotsmobile/bloc/firestore.bloc.dart';
import 'package:chessbotsmobile/models/user.doc.dart';
import 'package:flutter/material.dart';

class NerdPointActionDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FirestoreBloc _firestoreBloc =
        BlocProvider.of<FirestoreBloc>(context);
    return StreamBuilder<UserDoc>(
        stream: _firestoreBloc.userDoc$,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            int _nerdPoints = snapshot.data.nerdPoints ?? 0;
            return FlatButton(
              onPressed: () {},
              child: Text("${_nerdPoints}np"),
              textColor: Colors.white,
            );
          } else {
            return Container();
          }
        });
  }
}
