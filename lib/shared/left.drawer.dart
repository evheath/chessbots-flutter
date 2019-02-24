import 'package:flutter/material.dart';

import '../shared/custom.icons.dart';
import '../bloc/auth.bloc.dart';
import '../bloc/base.bloc.dart';

class LeftDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthBloc _authBloc = BlocProvider.of<AuthBloc>(context);
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            //TODO rip this thing out when I have a better place for signing out
            title: MaterialButton(
              child: Text("SignOut"),
              onPressed: () => _authBloc.event.add(SignOutEvent()),
            ),
          ),
          ListTile(
            leading: Icon(MyCustomIcons.beaker),
            title: Text('Lab'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/lab');
            },
          ),
          ListTile(
            leading: Icon(MyCustomIcons.cog_alt),
            title: Text('Assemble gambits'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/assemble');
            },
          )
        ],
      ),
    );
  }
}
