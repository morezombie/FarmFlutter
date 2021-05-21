import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'farmModel.dart';

class StatisticPage extends StatelessWidget {
  final CounterClerk clerk;

  const StatisticPage({Key key, this.clerk}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("营收统计")),
      body: Flex(direction: Axis.vertical, children: [
        Expanded(flex: 8, child: animalBar(clerk)),
        Expanded(flex: 12, child: moneyBar(clerk)),
      ]),
    );
  }

  Widget moneyBar(CounterClerk clerk) {
    List<MoneyStat> yearlyData = [], accumulateData = [];
    for (var i = 1; i < clerk.annualIncrease.length; ++i) {
      yearlyData.add(MoneyStat((2021 + i).toString(), clerk.annualIncrease[i]));
      accumulateData
          .add(MoneyStat((2021 + i).toString(), clerk.annualWealth[i]));
    }

    var moneyDataSerial = [
      charts.Series<MoneyStat, String>(
        id: '年度利润',
        colorFn: (_, __) => charts.MaterialPalette.purple.shadeDefault,
        domainFn: (MoneyStat stat, _) => stat.year,
        measureFn: (MoneyStat stat, _) => stat.money,
        data: yearlyData,
        labelAccessorFn: (MoneyStat stat, _) => '\$${stat.money.toString()}',
        insideLabelStyleAccessorFn: (MoneyStat stat, _) =>
            charts.TextStyleSpec(),
      ),
      charts.Series<MoneyStat, String>(
        id: '累计利润',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (MoneyStat stat, _) => stat.year,
        measureFn: (MoneyStat stat, _) => stat.money,
        data: accumulateData,
        labelAccessorFn: (MoneyStat stat, _) => '${stat.money.toString()}',
        outsideLabelStyleAccessorFn: (MoneyStat stat, _) =>
            charts.TextStyleSpec(),
      ),
    ];

    return charts.BarChart(
      moneyDataSerial,
      animate: true,
      barGroupingType: charts.BarGroupingType.stacked,
      barRendererDecorator: charts.BarLabelDecorator<String>(
          labelAnchor: charts.BarLabelAnchor.middle,
          labelPadding: -50),
      behaviors: [
        charts.SlidingViewport(),
        charts.PanAndZoomBehavior(),
        charts.DomainHighlighter(),
        charts.SeriesLegend()
      ],
      domainAxis:
          charts.OrdinalAxisSpec(viewport: charts.OrdinalViewport('2020', 4)),
      // vertical: false,
    );
  }

  Widget animalBar(CounterClerk clerk) {
    List<AnimalStat> cubData = [], femaleData = [];
    for (var i = 1; i < clerk.annualCub.length; ++i) {
      cubData.add(AnimalStat(i, clerk.annualCub[i]));
      femaleData.add(AnimalStat(i, clerk.annualMaturedFemale[i]));
    }

    var animalDataSerial = [
      charts.Series<AnimalStat, int>(
        id: '成年雌性数量',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (AnimalStat stat, _) => stat.year,
        measureFn: (AnimalStat stat, _) => stat.count,
        dashPatternFn: (_, __) => [8, 2, 4, 2],
        data: cubData,
      ),
      charts.Series<AnimalStat, int>(
        id: '幼崽数量',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (AnimalStat stat, _) => stat.year,
        measureFn: (AnimalStat stat, _) => stat.count,
        data: femaleData,
      )
    ];

    return charts.LineChart(
      animalDataSerial,
      animate: true,
      defaultRenderer: charts.LineRendererConfig(
          // 圆点大小
          radiusPx: 5.0,
          stacked: false,
          // 线的宽度
          strokeWidthPx: 2.0,
          // 是否显示线
          includeLine: true,
          // 是否显示圆点
          includePoints: true),
      behaviors: [
        charts.SeriesLegend(),
        charts.PanAndZoomBehavior(),
      ],
    );
  }
}

class AnimalStat {
  final int year;
  final int count;

  AnimalStat(this.year, this.count);
}

class MoneyStat {
  final String year;
  final int money;

  MoneyStat(this.year, this.money);
}
