import 'package:chessbotsmobile/shared/custom.icons.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ChessBotListTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text("Your bot"),
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              onPressed: () {},
              icon: Icon(FontAwesomeIcons.wrench),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(MyCustomIcons.cog_alt),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(FontAwesomeIcons.pencilAlt),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(FontAwesomeIcons.dollarSign),
            ),
          ],
        )
      ],
    );
  }
}
