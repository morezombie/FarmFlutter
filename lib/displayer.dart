import 'dart:math';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ChartTestPage extends StatelessWidget {
  const ChartTestPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("chart_flutter")),
      body: Column(children: [Container(height: 240, child: _simpleBar())]),
    );
  }

  Widget _simpleBar() {
    var random = Random();

    var data = [
      OrdinalSales('2014', random.nextInt(100)),
      OrdinalSales('2015', random.nextInt(100)),
      OrdinalSales('2016', random.nextInt(100)),
      OrdinalSales('2017', random.nextInt(100)),
    ];

    var seriesList = [
      charts.Series<OrdinalSales, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: data,
      )
    ];

    return charts.BarChart(
      seriesList,
      animate: true,
      barGroupingType: charts.BarGroupingType.stacked,
      vertical: false,
      barRendererDecorator: charts.BarLabelDecorator<String>(),
    );
  }
}

class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}
