import 'package:chessbotsmobile/bloc/base.bloc.dart';
import 'package:chessbotsmobile/models/user.doc.dart';
// import 'package:chessbotsmobile/shared/custom.icons.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:chessbotsmobile/bloc/firestore.bloc.dart';

class LeftDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FirestoreBloc _firestoreBloc =
        BlocProvider.of<FirestoreBloc>(context);
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            title: StreamBuilder<UserDoc>(
                stream: _firestoreBloc.userDoc$,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    String _name = snapshot.data.displayName ?? "Guest";
                    return Text("$_name");
                  } else {
                    return CircularProgressIndicator();
                  }
                }),
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.cog),
            title: Text('Settings'),
            onTap: () {
              Navigator.pop(context); // close the drawer
              Navigator.pushNamed(context, '/settings');
            },
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text('Help'),
            onTap: () {
              Navigator.pop(context); // close the drawer
              Navigator.pushNamed(context, '/help');
            },
          ),
        ],
      ),
    );
  }
}
