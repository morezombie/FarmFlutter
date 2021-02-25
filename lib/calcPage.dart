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

var itemList = <Widget>[FemaleItem(), MaleItem()];

// Define a corresponding State class.
// This class holds the data related to the Form.
class _InitiatorState extends State<Initiator> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final maleAge = TextEditingController();
  final maleNum = TextEditingController();
  final femaleAge = TextEditingController();
  final femaleNum = TextEditingController();

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
          child: Center(
              child: ListView(children: itemList))),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          return showDialog(
              context: context,
              builder: (context) {
                Male().showAge();
                return AlertDialog(
                  content: Text("You sure he can have a sex at " +
                      maleAge.text +
                      "th month and she can give birth to a baby after another " +
                      femaleAge.text +
                      " months?"),
                );
              });
        },
        child: Text("Go!"),
      ),
    );
  }
}

class FemaleItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text('母：'),
        BaseItem(),
        IconButton(
            icon: Icon(Icons.add_circle_outline), onPressed: () {
          itemList.add(this);
        }),
        IconButton(
            icon: Icon(Icons.remove_circle_outline), onPressed: () {
          itemList.remove(this);
        })
      ],
    );
  }
}

class MaleItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text('公：'),
        BaseItem(),
        IconButton(
            icon: Icon(Icons.add_circle_outline), onPressed: () {
          itemList.add(this);
        }),
        IconButton(
            icon: Icon(Icons.remove_circle_outline), onPressed: () {
              itemList.remove(this);
        })
      ],
    );
  }
}


class BaseItem extends StatefulWidget {
  @override
  _BaseItemState createState() => _BaseItemState();
}

class _BaseItemState extends State<BaseItem> {
  @override
  Widget build(BuildContext context) {
    return Flexible(child: Row(
      children: <Widget>[
        Flexible(
            child: TextField(
              // controller: maleNum,
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
              // controller: maleNum,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(),
                labelText: '数量',
              ),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
            )),
        Text('头'),
      ],
    ));
  }
}
