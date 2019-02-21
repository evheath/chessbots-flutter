import 'package:flutter/material.dart';

import '../shared/custom.icons.dart';

class LeftDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            // title: Text('Choose'),
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
