import 'package:chessbotsmobile/bloc/base.bloc.dart';
import 'package:chessbotsmobile/models/user.doc.dart';
import 'package:chessbotsmobile/shared/custom.icons.dart';
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
          // ListTile(
          //   leading: Icon(FontAwesomeIcons.userAlt),
          //   title: Text('Singleplayer'),
          //   onTap: () {
          //     Navigator.pushReplacementNamed(context, '/singleplayer');
          //   },
          // ),
          // ListTile(
          //   leading: Icon(MyCustomIcons.beaker),
          //   title: Text('Lab'),
          //   onTap: () {
          //     Navigator.pushReplacementNamed(context, '/lab');
          //   },
          // ),
          // ListTile(
          //   leading: Icon(FontAwesomeIcons.robot),
          //   title: Text('Bots'),
          //   onTap: () {
          //     Navigator.pushReplacementNamed(context, '/bots');
          //   },
          // ),
          // ListTile(
          //   leading: Icon(MyCustomIcons.cog_alt),
          //   title: Text('Gambits'),
          //   onTap: () {
          //     Navigator.pushReplacementNamed(context, '/assemble');
          //   },
          // ),
          ListTile(
            leading: Icon(FontAwesomeIcons.cog),
            title: Text('Settings'),
            onTap: () {
              Navigator.pop(context); // close the drawer
              Navigator.pushNamed(context, '/settings');
            },
          ),
          //TODO: help page for tutorials and discord links
          // ListTile(
          //   leading: Icon(FontAwesomeIcons.discord),
          //   title: Text('Discord'),
          //   onTap: _launchDiscordURL,
          // ),
        ],
      ),
    );
  }

  // _launchDiscordURL() async {
  //   const url = 'https://discord.gg/eC2WHe6';
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   }
  // }
}
