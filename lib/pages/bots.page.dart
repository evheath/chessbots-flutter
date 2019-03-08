import 'package:chessbotsmobile/bloc/base.bloc.dart';
import 'package:chessbotsmobile/bloc/firestore.bloc.dart';
import 'package:chessbotsmobile/models/user.doc.dart';
import 'package:chessbotsmobile/services/toaster.service.dart';
import 'package:chessbotsmobile/shared/chess_bot_list_tile.dart';
import 'package:chessbotsmobile/shared/nerd_point_action_display.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import '../shared/left.drawer.dart';

class BotsPage extends StatefulWidget {
  @override
  BotsPageState createState() {
    return BotsPageState();
  }
}

class BotsPageState extends State<BotsPage> {
  final FirestoreBloc _firestoreBloc = FirestoreBloc();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _showCreationDialog();
        },
      ),
      body: StreamBuilder<UserDoc>(
        stream: _firestoreBloc.userDoc$,
        builder: (context, snap) {
          if (!snap.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final _bots = snap.data.bots;
          print("snap in bot page updated");
          print(_bots);
          return Container(
            padding: EdgeInsets.all(10.0),
            child: ListView.builder(
              itemCount: _bots.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: ChessBotListTile(_bots[index]),
                );
              },
            ),
          );
        },
      ),
      appBar: AppBar(
        title: Row(
          children: [
            Icon(FontAwesomeIcons.robot),
            SizedBox(width: 10.0),
            //TODO check this on iphone SE
            Text("Chess Bots"),
          ],
        ),
        actions: <Widget>[
          NerdPointActionDisplay(),
        ],
      ),
      drawer: LeftDrawer(),
    );
  }

  void _showCreationDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Form(
              key: _formKey,
              child: AlertDialog(
                title: Text("Create a bot"),
                // content: Text("DERPDERPDERP"),
                content: TextFormField(
                  decoration: InputDecoration(
                    labelText: "Give your bot a name",
                  ),
                  autofocus: true,
                  onSaved: (String name) {
                    // print("creating $name");
                    _firestoreBloc.createBotDoc(name).then((_) {
                      // print("created bot");
                      Navigator.pop(context);
                    }).catchError((e) {
                      handleError(e, context);
                      // print("could not create bot");
                    });
                  },
                  validator: (name) {
                    if (name.isEmpty) {
                      return "You have to give it a name";
                    } else if (name.length > 20) {
                      return "Chill out, it is just a name";
                    }
                  },
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Discard"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  FlatButton(
                    child: Text("Create"),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                      }
                    },
                  ),
                ],
              ));
        });
  }
}
