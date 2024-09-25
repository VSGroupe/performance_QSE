
import 'package:d_chart/commons/data_model/data_model.dart';
import 'package:d_chart/ordinal/bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:perfqse/Views/pilotage/site1/production/tableau_bord/controller_tableau_bord/controller_tableau_bord.dart';
import 'package:perfqse/module/styled_scrollview.dart';

class BarChartCritere extends StatefulWidget {
  const BarChartCritere({super.key});

  @override
  State<BarChartCritere> createState() => _BarChartCritereState();
}

class _BarChartCritereState extends State<BarChartCritere> {

  final ControllerTableauBord controllerTableauBord = Get.find();
  List<dynamic> MesDonnees=[];
  @override
  void initState() {
    MesDonnees=controllerTableauBord.getPerformance()[0];
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 900,
      width: 1100,
      child: StyledScrollView(
        axis: Axis.vertical,
        child: Container(
          height: 600,
          width: 2000,
          child: StyledScrollView(
            axis: Axis.horizontal,
            child: DChartBarO(
            vertical: false,
            animate:true,
            groupList: [
              OrdinalGroup(id:"1",
                  color:Colors.blue,
                  data:List.generate(MesDonnees.length,
                          (index) => OrdinalData(domain:MesDonnees[index]["critere"]??"" , measure:MesDonnees[index]["perf"]??1 ))

              )
            ],
            ),
          ),
        ),
      ),
    );
  }
}
