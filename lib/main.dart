import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Retrieve Text Input',
      home: MyCustomForm(),
    );
  }
}

// Define a custom Form widget.
class MyCustomForm extends StatefulWidget {
  @override
  _MyCustomFormState createState() => _MyCustomFormState();
}

// Define a corresponding State class.
// This class holds the data related to the Form.
class _MyCustomFormState extends State<MyCustomForm> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final matureMonth = TextEditingController();
  final maxKeepMonth = TextEditingController();
  final carryMonth = TextEditingController();
  final birthPeriodMonth = TextEditingController();
  final numPerBirth = TextEditingController();
  final maleMonthCost = TextEditingController();
  final femaleMonthCost = TextEditingController();
  final priceCub = TextEditingController();
  final priceBigMale = TextEditingController();
  final priceBigFemale = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    matureMonth.dispose();
    maxKeepMonth.dispose();
    carryMonth.dispose();
    birthPeriodMonth.dispose();
    numPerBirth.dispose();
    maleMonthCost.dispose();
    femaleMonthCost.dispose();
    priceBigMale.dispose();
    priceBigFemale.dispose();
    priceCub.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('农场配置'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Center(
              child: ListView(children: <Widget>[
            Container(
                child: TextField(
              controller: matureMonth,
              decoration: InputDecoration(
                labelText: '成熟月龄',
              ),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
            )),
            Container(
                child: TextField(
              controller: maxKeepMonth,
              decoration: InputDecoration(
                labelText: '淘汰月龄',
              ),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
            )),
            Container(
                child: TextField(
              controller: numPerBirth,
              decoration: InputDecoration(
                labelText: '每胎产崽数量',
              ),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
            )),
            Container(
                child: TextField(
              controller: carryMonth,
              decoration: InputDecoration(
                labelText: '怀孕月数',
              ),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
            )),
            Container(
                child: TextField(
              controller: birthPeriodMonth,
              decoration: InputDecoration(
                labelText: '产崽间隔月数',
              ),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
            )),
            Container(
                child: TextField(
              controller: maleMonthCost,
              decoration: InputDecoration(
                labelText: '雄性每月饲料花费',
              ),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
            )),
            Container(
                child: TextField(
              controller: femaleMonthCost,
              decoration: InputDecoration(
                labelText: '雌性每月饲料花费',
              ),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
            )),
            Container(
                child: TextField(
              controller: priceBigMale,
              decoration: InputDecoration(
                labelText: '成年雄性买卖价格',
              ),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
            )),
            Container(
                child: TextField(
              controller: priceBigFemale,
              decoration: InputDecoration(
                labelText: '成年雌性买卖价格',
              ),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
            )),
            Container(
                child: TextField(
              controller: priceCub,
              decoration: InputDecoration(
                labelText: '幼崽买卖价格',
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
                return AlertDialog(
                  content: Text("You sure he can have a sex at " +
                      matureMonth.text +
                      "th month and she can give birth to a baby after another " +
                      carryMonth.text +
                      " months?"),
                );
              });
        },
        child: Text("Go!"),
      ),
    );
  }
}
