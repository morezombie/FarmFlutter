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
          padding: const EdgeInsets.all(50.0),
          child: Center(
              child: ListView(children: <Widget>[
            Container(
                child: TextField(
              controller: maleAge,
              decoration: InputDecoration(
                labelText: '成熟月龄',
              ),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
            )),
            Container(
                child: TextField(
              controller: maleNum,
              decoration: InputDecoration(
                labelText: '淘汰月龄',
              ),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
            )),
            Container(
                child: TextField(
              controller: femaleAge,
              decoration: InputDecoration(
                labelText: '怀孕月数',
              ),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
            )),
            Container(
                child: TextField(
              controller: femaleNum,
              decoration: InputDecoration(
                labelText: '产崽间隔月数',
              ),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
            )),
          ]))),
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
