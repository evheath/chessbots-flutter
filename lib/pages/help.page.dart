import 'package:chessbotsmobile/pages/assemble.tutorial.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Help")),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text("Gambits Tutorial"),
            trailing: RaisedButton(
                child: Icon(FontAwesomeIcons.cogs),
                // label: Text("Open"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AssembleTutorial(),
                      fullscreenDialog: true,
                    ),
                  ).then((_) async {
                    // marking the tutorial as seen
                    final SharedPreferences _prefsInstance =
                        await SharedPreferences.getInstance();
                    _prefsInstance.setBool("seenAssembleTutorial", true);
                  });
                }),
          ),
          Divider(),
          ListTile(
            title: Text("Terms and Conditions"),
            trailing: RaisedButton.icon(
              icon: Icon(Icons.open_in_browser),
              label: Text("Open"),
              onPressed: () => _launchURL(
                  'https://chessbotsmobile.firebaseapp.com/terms_and_conditions.html'),
            ),
          ),
          Divider(),
          ListTile(
            title: Text("Privacy Policy"),
            trailing: RaisedButton.icon(
              icon: Icon(Icons.open_in_browser),
              label: Text("Open"),
              onPressed: () => _launchURL(
                  'https://chessbotsmobile.firebaseapp.com/privacy_policy.html'),
            ),
          ),
          Divider(),
          ListTile(
            title: Text('View Changelog'),
            trailing: RaisedButton.icon(
              label: Text("Discord"),
              icon: Icon(FontAwesomeIcons.discord),
              onPressed: () => _launchURL('https://discord.gg/eC2WHe6'),
            ),
          ),
        ],
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
}
