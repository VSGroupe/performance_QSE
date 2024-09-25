/// Package import
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../tableau_bord/controller_tableau_bord/com_controller_tableau_bord.dart';

/// Render the default pie series.
class ChartConso extends StatefulWidget {
  const ChartConso({
    Key? key,
  }) : super(key: key);

  @override
  State<ChartConso> createState() => _ChartConsoState();
}

class _ChartConsoState extends State<ChartConso> {
  final ComControllerTableauBord controllerTb=Get.find();
  double PercentAllIndicateurValidate=0;
  double PercentAllIndicateurUnValidate=0;
  late  dynamic data;


  @override
  void initState() {
    super.initState();
    data=controllerTb.getAlimentationSectionSuivie();
  }

  @override
  Widget build(BuildContext context) {
    PercentAllIndicateurValidate=(((data[0]["numberIndicateurValidate"]+data[1]["numberIndicateurValidate"]+data[2]["numberIndicateurValidate"]+data[3]["numberIndicateurValidate"])/187)*100).ceilToDouble();
    PercentAllIndicateurUnValidate=(100-PercentAllIndicateurValidate).ceilToDouble();
    return Container(
      height: 200,
      width: 400,
      child:_buildDefaultPieChart(PercentAllIndicateurValidate,PercentAllIndicateurUnValidate)
    );
  }

  /// Returns the circular  chart with pie series.
  SfCircularChart _buildDefaultPieChart(double numberValidate,double numberUnValidate) {
    return SfCircularChart(
      title: ChartTitle(text: "Niveau de Collecte d'informations validées"),
      legend: Legend(isVisible:true),
        palette:[Colors.green,Colors.orange],
      series: _getDefaultPieSeries(numberValidate,numberUnValidate),
    );
  }

  /// Returns the pie series.
  List<PieSeries<ChartSampleData, String>> _getDefaultPieSeries(double numberValidate,double numberUnValidate) {
    return <PieSeries<ChartSampleData, String>>[
      PieSeries<ChartSampleData, String>(
          explode: true,
          explodeIndex: 0,
          explodeOffset: '20%',
          dataSource: <ChartSampleData>[
            ChartSampleData(x: 'Indicateurs renseignés', y: numberValidate, text: 'Indicateurs Validées \n $numberValidate %'),
            ChartSampleData(x: 'Indicateurs Non renseignés', y:numberUnValidate , text: 'Indicateurs Non Validées \n $numberUnValidate %'),
          ],
          xValueMapper: (ChartSampleData data, _) => data.x as String,
          yValueMapper: (ChartSampleData data, _) => data.y,
          dataLabelMapper: (ChartSampleData data, _) => data.text,
          startAngle: 90,
          endAngle: 90,
          dataLabelSettings: const DataLabelSettings(isVisible: true)),
    ];
  }
}

class ChartSampleData{
  final String x;
  final double y;
  final String text;
  const ChartSampleData({required this.x,required this.y,required this.text});
}