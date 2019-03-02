import 'package:chessbotsmobile/shared/empty_list_tile.dart';

import '../shared/gambit_list_tile.dart';
import '../shared/gambits.dart';
import 'package:flutter/material.dart';
import '../shared/chess_board.dart';
import '../bloc/game_controller.bloc.dart';

class AssembleTutorial extends StatefulWidget {
  @override
  _AssembleTutorialState createState() => _AssembleTutorialState();
}

class _AssembleTutorialState extends State<AssembleTutorial>
    with TickerProviderStateMixin {
  TabController _tutorialTabController;
  AnimationController _animationController;
  List<Widget> _tabs;

  @override
  void initState() {
    _animationController = AnimationController(
        duration: Duration(milliseconds: 3000), vsync: this);
    // _animationController is used by multiple children
    // and in the same way, so repeating here makes sense
    _animationController.repeat();

    // notice length must be updated if tabs are added
    _tutorialTabController = TabController(length: 6, vsync: this);

    //TODO tabs:
    // - help icon takes you to demo
    _tabs = [
      EmptyGambitsTab(_tutorialTabController),
      UndesirableTab(_animationController),
      RearrangeOrderTab(_tutorialTabController),
      DesirableOrderTab(_animationController),
      SpecialGambitsTab(),
      SwipeTab(_animationController),
    ];

    super.initState();
  }

  @override
  void dispose() {
    _tutorialTabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("How to assemble gambits"),
        backgroundColor: Colors.purple,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: TabBarView(
              controller: _tutorialTabController,
              children: _tabs,
            ),
          ),
          TabPageSelector(
            controller: _tutorialTabController,
            selectedColor: Colors.grey,
          ),
          // RaisedButton(
          //   child: Text('Close'),
          //   onPressed: () => Navigator.pop(context),
          // )
        ],
      ),
    );
  }
}

class DesirableBoard extends StatelessWidget {
  final AnimationController controller;
  final Animation<double> number;

  DesirableBoard({Key key, this.controller})
      : number = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(controller),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: controller,
        builder: (context, widget) {
          return number.value >= 0.5 // half of the time
              ? ChessBoard(
                  enableUserMoves: false,
                  onMove: (move) {},
                  onDraw: () {},
                  chessBoardController: GameControllerBloc(
                      initialPosition:
                          'rnbqkb1r/ppppp1pp/8/5pn1/3P2Q1/4P3/PPP2PPP/RNB1KBNR w KQkq - 0 1'),
                )
              : ChessBoard(
                  enableUserMoves: false,
                  onMove: (move) {},
                  onDraw: () {},
                  chessBoardController: GameControllerBloc(
                      initialPosition:
                          'rnbqkb1r/ppppp1pp/8/5pQ1/3P4/4P3/PPP2PPP/RNB1KBNR w KQkq - 0 1'),
                );
        });
  }
}

class UndesirableBoard extends StatelessWidget {
  final AnimationController controller;
  final Animation<double> number;

  UndesirableBoard({Key key, this.controller})
      : number = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(controller),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: controller,
        builder: (context, widget) {
          return number.value >= 0.5 // half of the time
              ? ChessBoard(
                  enableUserMoves: false,
                  onMove: (move) {},
                  onDraw: () {},
                  chessBoardController: GameControllerBloc(
                      initialPosition:
                          'rnbqkb1r/ppppp1pp/8/5Qn1/3P4/4P3/PPP2PPP/RNB1KBNR w KQkq - 0 1'),
                )
              : ChessBoard(
                  enableUserMoves: false,
                  onMove: (move) {},
                  onDraw: () {},
                  chessBoardController: GameControllerBloc(
                      initialPosition:
                          'rnbqkb1r/ppppp1pp/8/5pn1/3P2Q1/4P3/PPP2PPP/RNB1KBNR w KQkq - 0 1'),
                );
        });
  }
}

class SwipingAnimation extends StatelessWidget {
  SwipingAnimation({Key key, this.controller})
      : translation = Tween<double>(
          begin: 0.0,
          end: 500.0,
        ).animate(
          CurvedAnimation(parent: controller, curve: Curves.ease),
        ),
        super(key: key);

  final AnimationController controller;
  final Animation<double> translation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: controller,
        builder: (context, widget) {
          return Transform.translate(
            offset: Offset(translation.value, 0),
            child: GambitListTile(gambit: CheckOpponent()),
          );
        });
  }
}

class UndesirableTab extends StatelessWidget {
  final AnimationController _animationController;
  UndesirableTab(this._animationController);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Column(children: [
          GambitListTile(gambit: CapturePawn()),
          GambitListTile(gambit: CaptureKnight())
        ]),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text.rich(TextSpan(
            text: "Your bot will make moves based on the ",
            children: [
              TextSpan(
                  text: "order",
                  style: TextStyle(decoration: TextDecoration.underline)),
              TextSpan(text: " of your gambits"),
            ],
          )),
        ),
        UndesirableBoard(controller: _animationController),
        Text("Notice how the knight isn't captured?"),
      ],
    );
  }
}

/// Note: this Tab should be second to tab
class RearrangeOrderTab extends StatelessWidget {
  /// Needed so this tab can animate to the next tab
  final TabController _tabController;
  RearrangeOrderTab(this._tabController);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Expanded(
          child: ReorderableListView(
              padding: const EdgeInsets.all(10),
              scrollDirection: Axis.vertical,
              onReorder: (oldIndex, newIndex) {
                int nextIndex =
                    _tabController.index >= _tabController.previousIndex
                        ? _tabController.index + 1
                        : _tabController.previousIndex;
                _tabController.animateTo(nextIndex);
              },
              header: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text("Press and hold to rearrange gambits"),
              ),
              children: [
                GambitListTile(key: Key('2'), gambit: CapturePawn()),
                GambitListTile(key: Key('1'), gambit: CaptureKnight())
              ]),
        ),
        // Text("Go on, give it a try"),
      ],
    );
  }
}

class DesirableOrderTab extends StatelessWidget {
  final AnimationController _animationController;
  DesirableOrderTab(this._animationController);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Column(children: [
          GambitListTile(gambit: CaptureKnight()),
          GambitListTile(gambit: CapturePawn())
        ]),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
                "Now 'Capture Knight' gets evaluated before 'Capture Pawn'")),
        DesirableBoard(controller: _animationController),
        Text("That's better!"),
      ],
    );
  }
}

class SpecialGambitsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text("These two gambits are special:"),
        ),
        Column(children: [
          GambitListTile(gambit: CheckmateOpponent()),
          GambitListTile(gambit: MoveRandomPiece())
        ]),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text("You can't move or change them."),
        ),
      ],
    );
  }
}

class SwipeTab extends StatelessWidget {
  final AnimationController _animationController;
  SwipeTab(this._animationController);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text("Lastly,"),
        // TODO have empty gambit animation in underneath
        SwipingAnimation(controller: _animationController),
        Text("Swipe to empty a gambit!"),
      ],
    );
  }
}

class EmptyGambitsTab extends StatelessWidget {
  /// Needed so this tab can animate to the next tab
  final TabController _tabController;
  EmptyGambitsTab(this._tabController);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text("Tap on an empty boxes to select a gambit"),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: GestureDetector(
            child: EmptyListTile(),
            onTap: () {
              int nextIndex =
                  _tabController.index >= _tabController.previousIndex
                      ? _tabController.index + 1
                      : _tabController.previousIndex;
              _tabController.animateTo(nextIndex);
            },
          ),
        ),
      ],
    );
  }
}
