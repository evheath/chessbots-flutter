import 'package:chessbotsmobile/bloc/base.bloc.dart';
import 'package:chessbotsmobile/bloc/firestore.bloc.dart';
import 'package:flutter/material.dart';

class NerdPointActionDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FirestoreBloc _firestoreBloc =
        BlocProvider.of<FirestoreBloc>(context);
    return StreamBuilder<Map<String, dynamic>>(
        stream: _firestoreBloc.userDoc,
        initialData: {"nerdPoints": 0},
        builder: (context, snapshot) {
          int _nerdPoints = snapshot.data['nerdPoints'] ?? 0;
          return FlatButton.icon(
            onPressed: () {},
            icon: Icon(Icons.attach_money),
            label: Text("$_nerdPoints"),
          );
        });
  }
}
