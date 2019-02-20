/// Page for reordering gambits, similar to right-hand pane in web-app

import 'package:flutter/material.dart';

import '../shared/left.drawer.dart';
import '../shared/custom.icons.dart';

class AssemblePage extends StatefulWidget {
  @override
  AssemblePageState createState() {
    return AssemblePageState();
  }
}

class AssemblePageState extends State<AssemblePage> {
  List<String> _gambits = ['derp', 'merp', 'herp'];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: ReorderableListView(
            scrollDirection: Axis.vertical,
            onReorder: (oldIndex, newIndex) {
              if (oldIndex < newIndex) {
                // removing the item at oldIndex will shorten the list by 1.
                newIndex -= 1;
              }
              final String element = _gambits.removeAt(oldIndex);
              _gambits.insert(newIndex, element);
              setState(() {});
            },
            header: Text('I am the header'),
            children: List.generate(_gambits.length, (index) {
              return ListTile(
                key: Key(_gambits[index]),
                leading: Text('$index'),
                title: Text(_gambits[index]),
                trailing: Icon(Icons.close),
              );
            })
            // [
            // Card(child: Text('I am a gambit')),
            // Card(child: Text('Me too')),
            // ListTile(
            //   key: Key('inital first'),
            //   leading: Text('1'),
            //   title: Text('Am I the best?'),
            //   trailing: Icon(Icons.close),
            // ),
            // ListTile(
            //   key: Key('inital second'),
            //   leading: Text('2'),
            //   title: Text('It is me'),
            //   trailing: Icon(Icons.play_arrow),
            // ),
            // ],
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
