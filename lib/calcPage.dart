import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'configPage.dart';
import 'farmModel.dart';
import 'displayer.dart';
import 'infoDrawer.dart';
import 'updater.dart';

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

  final inputKey = GlobalKey<_InputItemsState>();

  var inputs;

  var model = Farm();

  void makeInput(String genderStr) {
    final key = GlobalKey<_BaseItemState>();
    var item = BaseItem(key: key, genderStr: genderStr);
    inputs.list.add(item);
    inputs.keys.add(key);
  }

  @override
  void initState() {
    inputs = InputItems(
        key: inputKey,
        list: List<BaseItem>.empty(growable: true),
        keys: List<GlobalKey<_BaseItemState>>.empty(growable: true));
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
          model.reset();
          for (var key in inputs.keys) {
            final num = int.parse(key.currentState.numController.text);
            final age = int.parse(key.currentState.ageController.text);
            final isMale = key.currentState.genderStr == '公';
            model.addAnimal(isMale, age, num: num);
          }
          model.run(int.parse(inputKey.currentState.runningMonths.text));
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return StatisticPage(clerk: model.clerk);
          }));
        },
        child: Text("Go!"),
      ),
      drawer: makeInfoDrawer(context, () {
        setState(() {});
      }),
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
  final runningMonths= TextEditingController(text: '120');

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
        Image(image: AssetImage("lib/assets/clock.webp"), width: 40,),
        SizedBox(width: 10,),
            Text('运营时长：', style: TextStyle(fontSize: 20, color: Colors.purpleAccent),),
            SizedBox(
              width: 50,
              child: TextField(
              controller: runningMonths,
              decoration: InputDecoration(
                enabledBorder: InputBorder.none,
                hintText: '月数',
                isCollapsed: true,
                isDense: true,
              ),
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
            )
            ),
            Text('个月', style: TextStyle(fontSize: 20, color: Colors.purpleAccent)),
            Spacer(),
          ],
        ),
        Expanded(
            child: ListView.builder(
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
                        final key = GlobalKey<_BaseItemState>();
                        var newItem = BaseItem(key: key, genderStr: curItem.genderStr);
                        widget.list.add(newItem);
                        widget.keys.add(key);
                      });
                    }),
                IconButton(
                    icon: Icon(Icons.remove_circle_outline),
                    onPressed: () {
                      if (index < 2) return;
                      setState(() {
                        widget.list.removeAt(index);
                        widget.keys.removeAt(index);
                      });
                    })
              ],
            );
          },
        )),
      ],
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
  final ageController = TextEditingController(text: '18');
  final numController = TextEditingController(text: '1');

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
        Image(image: AssetImage(genderStr == '公' ? "lib/assets/furious_ox.png" : "lib/assets/furious_cow.gif"), width: 50,),
        SizedBox(width: 10,),
        Text(genderStr + "：", style: TextStyle(fontSize: 18, color: Colors.blueGrey)),
        Flexible(
            child: TextField(
          controller: ageController,
          decoration: InputDecoration(
            hintText: '月龄',
            enabledBorder: InputBorder.none,
          ),
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.end,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          keyboardType: TextInputType.number,
        )),
        Text('个月，', style: TextStyle(fontSize: 18, color: Colors.blueGrey)),
        Flexible(
            child: TextField(
          controller: numController,
          style: TextStyle(fontSize: 18),
          decoration: InputDecoration(
            enabledBorder: InputBorder.none,
            hintText: '数量',
          ),
          textAlign: TextAlign.end,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          keyboardType: TextInputType.number,
        )),
        Text('头', style: TextStyle(fontSize: 18, color: Colors.blueGrey)),
      ],
    );
  }
}
