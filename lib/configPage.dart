import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'farmConfig.dart';

class ConfigPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ParamForm();
  }
}

// Define a custom Form widget.
class ParamForm extends StatefulWidget {
  @override
  _ParamFormState createState() => _ParamFormState();
}

// Define a corresponding State class.
// This class holds the data related to the Form.
class _ParamFormState extends State<ParamForm> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final matureMonth =
      TextEditingController(text: config.maturedMonth.toString());
  final maxKeepMonth =
      TextEditingController(text: config.maxKeepingMonth.toString());
  final numPerBirth =
      TextEditingController(text: config.numPerBirth.toString());
  final carryMonth = TextEditingController(text: config.carryMonth.toString());
  final birthPeriodMonth =
      TextEditingController(text: config.birthPeriodMonth.toString());
  final femaleMonthCost =
      TextEditingController(text: config.feedFemaleMonth.toString());
  final maleMonthCost =
      TextEditingController(text: config.feedMaleMonth.toString());
  final priceBigMale =
      TextEditingController(text: config.priceMaturedMale.toString());
  final priceBigFemale =
      TextEditingController(text: config.priceMaturedFemale.toString());
  final priceCub = TextEditingController(text: config.priceCub.toString());

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

  Widget _makeContainer(var controller, String label) {
    return Container(
        child: TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
      ),
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      keyboardType: TextInputType.number,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('农场配置'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.autorenew_sharp),
              tooltip: '',
              onPressed: () {
                return showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Text('重置所有参数？'),
                        actions: <Widget>[
                          FlatButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: Text('确定')),
                          TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: Text('取消')),
                        ],
                      );
                    }).then((confirm) {
                  if (confirm == null) return;
                  if (!confirm) return;
                  setState(() {
                    config.restore();
                    matureMonth.text = config.maturedMonth.toString();
                    maxKeepMonth.text = config.maxKeepingMonth.toString();
                    numPerBirth.text = config.numPerBirth.toString();
                    carryMonth.text = config.carryMonth.toString();
                    birthPeriodMonth.text = config.birthPeriodMonth.toString();
                    maleMonthCost.text = config.feedMaleMonth.toString();
                    femaleMonthCost.text = config.feedFemaleMonth.toString();
                    priceBigMale.text = config.priceMaturedMale.toString();
                    priceBigFemale.text = config.priceMaturedFemale.toString();
                    priceCub.text = config.priceCub.toString();
                  });
                });
              })
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Center(
              child: ListView(children: <Widget>[
            _makeContainer(matureMonth, '成熟月龄'),
            _makeContainer(maxKeepMonth, '淘汰月龄'),
            _makeContainer(numPerBirth, '每胎产崽数量'),
            _makeContainer(carryMonth, '怀孕月数'),
            _makeContainer(birthPeriodMonth, '产崽间隔月数'),
            _makeContainer(maleMonthCost, '雄性每月饲料花费'),
            _makeContainer(femaleMonthCost, '雌性每月饲料花费'),
            _makeContainer(priceBigMale, '成年雄性买卖价格'),
            _makeContainer(priceBigFemale, '成年雌性买卖价格'),
            _makeContainer(priceCub, '幼崽买卖价格'),
          ]))),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          config.maturedMonth = int.parse(matureMonth.text);
          config.maxKeepingMonth = int.parse(maxKeepMonth.text);
          config.numPerBirth = int.parse(numPerBirth.text);
          config.carryMonth = int.parse(carryMonth.text);
          config.birthPeriodMonth = int.parse(birthPeriodMonth.text);
          config.feedMaleMonth = int.parse(maleMonthCost.text);
          config.feedFemaleMonth = int.parse(femaleMonthCost.text);
          config.priceMaturedFemale = int.parse(priceBigFemale.text);
          config.priceMaturedMale = int.parse(priceBigMale.text);
          config.priceCub = int.parse(priceCub.text);
          Navigator.pop(context);
        },
        child: Text("Done!"),
      ),
    );
  }
}
