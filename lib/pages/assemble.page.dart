/// Page for reordering gambits, similar to right-hand pane in web-app

import 'package:flutter/material.dart';

import '../shared/left.drawer.dart';
import '../shared/custom.icons.dart';

import '../bloc/base.bloc.dart';
import '../bloc/gambits.bloc.dart';

class AssemblePage extends StatefulWidget {
  @override
  AssemblePageState createState() {
    return AssemblePageState();
  }
}

class AssemblePageState extends State<AssemblePage> {
  // List<String> _gambits = ['derp', 'merp', 'herp'];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final GambitsBloc gambitsBloc = BlocProvider.of<GambitsBloc>(context);
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: StreamBuilder(
          initialData: [Gambit(title: 'assemble1'), Gambit(title: 'assemble2')],
          stream: gambitsBloc.gambits,
          builder: (context, snapshot) {
            List<Gambit> _gambits = snapshot.data;
            return ReorderableListView(
              scrollDirection: Axis.vertical,
              onReorder: (oldIndex, newIndex) {
                gambitsBloc.reorder.add(ReorderEvent(oldIndex, newIndex));
              },
              header: Text('I am the header'),
              children: List.generate(_gambits.length, (index) {
                return ListTile(
                  key: Key(_gambits[index].title),
                  leading: Text('$index'),
                  title: Text(_gambits[index].title),
                  trailing: Icon(_gambits[index].icon),
                );
              }),
            );
          },
        ),
      ),
      appBar: AppBar(
        title: Row(
          children: [
            Icon(MyCustomIcons.cog_alt),
            SizedBox(width: 10.0),
            Text("Assemble your gambits"),
          ],
        ),
      ),
      drawer: LeftDrawer(),
    );
  } // Build

}
