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

  @override
  void initState() {
    _tutorialTabController = TabController(length: 2, vsync: this);
    _animationController = AnimationController(
        duration: Duration(milliseconds: 3000), vsync: this);
    _animationController
        .repeat(); // used by multiple children so we are always using it
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
    //TODO tabs:
    // - click on empty to fill
    // - top and bottom cannot be changed
    // - help icon takes you to demo
    // - drag and drop to reorder
    // _tabs needs to be in build to access animation controller
    List<Widget> _tabs = [
      //tab 1
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(children: [
            GambitListTile(gambit: CapturePawn()),
            GambitListTile(gambit: CaptureKnight())
          ]),
          Text("Your bot will make moves based on the order of your gambits"),
          UndesirableBoard(controller: _animationController),
          Text("Notice how the knight isn't captured?"),
        ],
      ),
      //tab2
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          // TODO have empty gambit animation in underneath
          SwipingAnimation(controller: _animationController),
          Text("Swipe to dismiss a gambit!"),
        ],
      ),
    ];

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
          RaisedButton(
            child: Text('Close'),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
    );
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
                  onMove: (move) {},
                  onDraw: () {},
                  chessBoardController: GameControllerBloc(
                      initialPosition:
                          'rnbqkb1r/ppppp1pp/8/5pn1/3P2Q1/4P3/PPP2PPP/RNB1KBNR w KQkq - 0 1'),
                )
              : ChessBoard(
                  onMove: (move) {},
                  onDraw: () {},
                  chessBoardController: GameControllerBloc(
                      initialPosition:
                          'rnbqkb1r/ppppp1pp/8/5Qn1/3P4/4P3/PPP2PPP/RNB1KBNR w KQkq - 0 1'),
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
