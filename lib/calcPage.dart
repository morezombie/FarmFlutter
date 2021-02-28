import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'configPage.dart';
import 'farmModel.dart';

class Calculator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Initiator();
  }
}

// Define a custom Form widget.
class Initiator extends StatefulWidget {
  @override
  _InitiatorState createState() => _InitiatorState();
}

// Define a corresponding State class.
// This class holds the data related to the Form.
class _InitiatorState extends State<Initiator> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final maleAge = TextEditingController();
  final maleNum = TextEditingController();
  final femaleAge = TextEditingController();
  final femaleNum = TextEditingController();

  var inputs = InputItems(
      list: List<BaseItem>(), keys: List<GlobalKey<_BaseItemState>>());

  var model = Farm();

  void makeInput(String genderStr) {
    final key = GlobalKey<_BaseItemState>();
    var item = BaseItem(key: key, genderStr: genderStr);
    inputs.list.add(item);
    inputs.keys.add(key);
  }

  @override
  void initState() {
    makeInput('公');
    makeInput('母');
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    maleAge.dispose();
    maleNum.dispose();
    femaleAge.dispose();
    femaleNum.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('农场计算器'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              //导航到新路由
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ConfigPage();
              }));
            },
          )
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.fromLTRB(30, 50, 10, 10),
          child: Center(child: inputs)),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          for (var key in inputs.keys) {
            final num = int.parse(key.currentState.numController.text);
            final age = int.parse(key.currentState.ageController.text);
            final isMale = key.currentState.genderStr == '公';
            model.addAnimal(isMale, age, num: num);
          }
          model.run(120);
        },
        child: Text("Go!"),
      ),
    );
  }
}

class InputItems extends StatefulWidget {
  final List<BaseItem> list;
  final List<GlobalKey<_BaseItemState>> keys;

  const InputItems({Key key, this.list, this.keys}) : super(key: key);

  @override
  _InputItemsState createState() => _InputItemsState();
}

class _InputItemsState extends State<InputItems> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.list.length,
      itemBuilder: (BuildContext context, int index) {
        var curItem = widget.list[index];
        return Row(
          children: <Widget>[
            Expanded(child: curItem),
            IconButton(
                icon: Icon(Icons.add_circle_outline),
                onPressed: () {
                  setState(() {
                    print(curItem.genderStr);
                    var newItem = BaseItem(genderStr: curItem.genderStr);
                    widget.list.add(newItem);
                  });
                }),
            IconButton(
                icon: Icon(Icons.remove_circle_outline),
                onPressed: () {
                  if (index < 2) return;
                  setState(() {
                    widget.list.removeAt(index);
                  });
                })
          ],
        );
      },
    );
  }
}

class BaseItem extends StatefulWidget {
  final genderStr;

  const BaseItem({Key key, this.genderStr}) : super(key: key);

  @override
  _BaseItemState createState() => _BaseItemState();
}

class _BaseItemState extends State<BaseItem> {
  var genderStr;
  final ageController = TextEditingController();
  final numController = TextEditingController();

  @override
  void initState() {
    genderStr = widget.genderStr;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(genderStr + "："),
        Flexible(
            child: TextField(
          controller: ageController,
          decoration: InputDecoration(
            labelText: '月龄',
            enabledBorder: OutlineInputBorder(),
          ),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          keyboardType: TextInputType.number,
        )),
        Text('个月，'),
        Flexible(
            child: TextField(
          controller: numController,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(),
            labelText: '数量',
          ),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          keyboardType: TextInputType.number,
        )),
        Text('头'),
      ],
    );
  }
}
