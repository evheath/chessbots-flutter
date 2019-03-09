import 'package:chessbotsmobile/bloc/firestore.bloc.dart';
import 'package:chessbotsmobile/models/gambit.dart';
import 'package:chessbotsmobile/models/user.doc.dart';
import 'package:chessbotsmobile/pages/demo.page.dart';
import 'package:flutter/material.dart';

class GambitListTile extends StatelessWidget {
  final Gambit gambit;
  final Key key;
  final bool disabled;

  GambitListTile({@required this.gambit, this.key, this.disabled = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(5.0),
          color: gambit.color.withAlpha(75),
        ),
        child: ListTile(
            enabled: !disabled,
            title: Text(
              gambit.title,
              softWrap: false,
            ),
            leading: Hero(
              tag: gambit.title,
              child: CircleAvatar(
                child: Icon(gambit.icon, color: Colors.white),
                backgroundColor: gambit.color,
              ),
            ),
            trailing: StreamBuilder<UserDoc>(
                stream: FirestoreBloc().userDoc$,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }
                  List<String> _ownedGambits = snapshot.data.ownedGambits;
                  if (_ownedGambits.contains(gambit.title) ||
                      gambit.cost == 0) {
                    // user owns the gambit or it is free
                    return IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DemoPage(gambit)));
                      },
                      icon: Icon(Icons.help),
                    );
                  } else {
                    //user does not own the gambit, so display price
                    return Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: <Widget>[
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DemoPage(gambit)));
                          },
                          icon: Icon(Icons.help),
                        ),
                        Text(
                          "${gambit.cost}",
                          textAlign: TextAlign.center,
                        ),
                      ],
                    );
                  }
                })),
      ),
    );
  }
}
