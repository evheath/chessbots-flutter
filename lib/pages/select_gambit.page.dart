import 'package:chessbotsmobile/bloc/firestore.bloc.dart';
import 'package:chessbotsmobile/models/gambit.dart';
import 'package:chessbotsmobile/models/user.doc.dart';
import 'package:chessbotsmobile/services/toaster.service.dart';
import 'package:chessbotsmobile/shared/all_gambits.dart';
import 'package:chessbotsmobile/shared/gambit_list_tile.dart';
import 'package:chessbotsmobile/shared/gambits.dart';
import 'package:chessbotsmobile/shared/nerd_point_action_display.dart';
import 'package:chessbotsmobile/models/chess_bot.dart';
import 'package:flutter/material.dart';

/// This page is always pushed
///
/// The underlying page will be expecting a gambit in the pop
class SelectGambitPage extends StatelessWidget {
  final ChessBot _chessBot;
  SelectGambitPage(this._chessBot);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [NerdPointActionDisplay()],
        backgroundColor: Colors.grey,
        title: SingleChildScrollView(
          child: Text("Select a gambit"),
          scrollDirection: Axis.horizontal,
        ),
      ),
      body: StreamBuilder(
          initialData: [MoveRandomPiece()], // need for error prevention
          stream: _chessBot.gambits,
          builder: (context, snapshot) {
            List<Gambit> _currentGambits = snapshot.data;

            List<Gambit> allGambitsSorted = allGambits
              ..sort((a, b) => a.cost.compareTo(b.cost));

            return ListView(
              // gambit tiles
              children: List.generate(allGambitsSorted.length, (innerIndex) {
                Gambit _gambit = allGambitsSorted[innerIndex];
                bool shouldBeDisabled =
                    _currentGambits.contains(_gambit) ? true : false;
                return GestureDetector(
                  onTap: shouldBeDisabled
                      ? () => handleError(
                          "Your bot is already using '${_gambit.title}'",
                          context)
                      : () => _handleSelection(context, _gambit),
                  child: GambitListTile(
                    gambit: _gambit,
                    disabled: shouldBeDisabled,
                  ),
                );
              }),
            );
          }),
    );
  }

  void _handleSelection(BuildContext context, Gambit _gambit) async {
    UserDoc _currentUserData = await FirestoreBloc().userDoc$.first;
    List<String> _ownedGambits = _currentUserData.ownedGambits;

    // check if user owns this gambit or it is free
    // if not, prompt a purchase
    if (_ownedGambits.contains(_gambit.title) || _gambit.cost == 0) {
      _selectGambit(context, _gambit);
    } else {
      _purchaseGambitPrompt(context, _gambit);
    }
  }

  void _purchaseGambitPrompt(BuildContext context, Gambit _gambit) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String plural = _gambit.cost > 1 ? 's' : '';
        return AlertDialog(
          title: Text("Purchase gambit"),
          content: SingleChildScrollView(
            child: Column(children: [
              Text(
                  "Buy '${_gambit.title}' for ${_gambit.cost} nerd point$plural?"),
              SizedBox(
                height: 20,
              ),
              Text("Once you buy a gambit, you can use it on any bot!"),
            ]),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Nah"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("Yes"),
              onPressed: () {
                FirestoreBloc().attemptToBuyGambit(_gambit).then((_) {
                  Navigator.pop(context); // leave purchase dialog
                  _selectGambit(context, _gambit); // select gambit
                }).catchError((e) {
                  Navigator.of(context).pop(); // leave purchase
                  handleError(e, context);
                });
              },
            ),
          ],
        );
      },
    );
  }

  void _selectGambit(BuildContext context, Gambit _gambit) {
    Navigator.pop(context, _gambit);
  }
}
