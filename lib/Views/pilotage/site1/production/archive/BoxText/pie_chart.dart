import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class PieChartDonnut extends StatefulWidget {
  final double numFull;
  final Color colorFull;
  final Color colorEmpty;
  const PieChartDonnut({super.key,
    required this.numFull,
    required this.colorFull,
    required this.colorEmpty});

  @override
  State<PieChartDonnut> createState() => PieChartDonnutState();
}

class PieChartDonnutState extends State<PieChartDonnut> {
  int touchedIndex = -1;

  final gradientList = <List<Color>>[
    [
      Color.fromRGBO(223, 250, 92, 1),
      Color.fromRGBO(129, 250, 112, 1),
    ],
    [
      Color.fromRGBO(129, 182, 205, 1),
      Color.fromRGBO(91, 253, 199, 1),
    ],
    [
      Color.fromRGBO(175, 63, 62, 1.0),
      Color.fromRGBO(254, 154, 92, 1),
    ]
  ];

  @override
  Widget build(BuildContext context) {
    final double numEmpCal=100-widget.numFull;
    Map<String, double> dataMap = {
      "numFull": widget.numFull,
      "numEmpty":numEmpCal.abs()
    };

    List<Color> colorList = [
      widget.colorFull,
      widget.colorEmpty
    ];

    return Center(
      child: PieChart(
        dataMap:dataMap,
        chartType: ChartType.ring,
        baseChartColor: Colors.grey[50]!.withOpacity(0.15),
        colorList: colorList,
        initialAngleInDegree: 0,
        chartRadius:100,
        ringStrokeWidth:13,
        animationDuration: const Duration(seconds: 4),
        centerText: "",
        chartValuesOptions: ChartValuesOptions(
          showChartValuesInPercentage: true,
        ),
        legendOptions:const LegendOptions(
            showLegends:false,
            legendPosition:LegendPosition.top
        ),
        totalValue: 100,
      ),
    );
  }

}