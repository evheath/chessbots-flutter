import 'package:chessbotsmobile/bloc/game_controller.bloc.dart';
import 'package:chessbotsmobile/shared/chess_board.dart';
import 'package:chessbotsmobile/shared/empty_list_tile.dart';
import 'package:chessbotsmobile/shared/gambit_list_tile.dart';
import 'package:chessbotsmobile/shared/gambits.dart';
import 'package:flutter/material.dart';

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
    _tutorialTabController = TabController(length: 7, vsync: this);

    _tabs = [
      EmptyGambitsTab(_tutorialTabController),
      QuestionMarkDemoTab(),
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
      body: SafeArea(
        child: Column(
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
          ],
        ),
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
    return Stack(
      children: [
        EmptyListTile(),
        AnimatedBuilder(
            animation: controller,
            builder: (context, widget) {
              return Transform.translate(
                offset: Offset(translation.value, 0),
                child: GambitListTile(gambit: CheckOpponentUsingRandom()),
              );
            }),
      ],
    );
  }
}

class UndesirableTab extends StatelessWidget {
  final AnimationController _animationController;
  UndesirableTab(this._animationController);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(children: [
            GambitListTile(gambit: CapturePawnUsingRandom()),
            GambitListTile(gambit: CaptureKnightUsingRandom())
          ]),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text.rich(
              TextSpan(
                style: TextStyle(fontSize: 25),
                text: "Your bot will make moves based on the ",
                children: [
                  TextSpan(
                      text: "order",
                      style: TextStyle(decoration: TextDecoration.underline)),
                  TextSpan(text: " of your gambits"),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          UndesirableBoard(controller: _animationController),
          Text(
            "Notice how the knight isn't captured?",
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
        ],
      ),
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
                child: Text(
                  "Press and hold to rearrange gambits",
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ),
              children: [
                GambitListTile(key: Key('2'), gambit: CapturePawnUsingRandom()),
                GambitListTile(
                    key: Key('1'), gambit: CaptureKnightUsingRandom())
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
          GambitListTile(gambit: CaptureKnightUsingRandom()),
          GambitListTile(gambit: CapturePawnUsingRandom())
        ]),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            "Now 'Capture Knight' gets evaluated before 'Capture Pawn'",
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
        ),
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
          child: Text(
            "These two gambits are special:",
            style: TextStyle(fontSize: 25),
            textAlign: TextAlign.center,
          ),
        ),
        Column(children: [
          GambitListTile(gambit: CheckmateOpponent()),
          GambitListTile(gambit: MoveRandomPiece())
        ]),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            "You can't move or change them.",
            style: TextStyle(fontSize: 25),
            textAlign: TextAlign.center,
          ),
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
        SwipingAnimation(controller: _animationController),
        Text(
          "Swipe to empty a gambit!",
          style: TextStyle(fontSize: 30),
          textAlign: TextAlign.center,
        ),
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
          child: Text(
            "Tap on empty boxes to select a gambit",
            style: TextStyle(fontSize: 30),
            textAlign: TextAlign.center,
          ),
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

class QuestionMarkDemoTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 10.0),
        //   child: Text("These two gambits are special:"),
        // ),
        Column(children: [
          GambitListTile(gambit: CastleKingSide()),
          GambitListTile(gambit: PromotePawnToKnight())
        ]),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            "If you are unsure what a gambit does, tap the question mark to see a demo.",
            style: TextStyle(fontSize: 30),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
