import 'package:d_chart/commons/data_model/data_model.dart';
import 'package:d_chart/ordinal/bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:perfqse/Views/pilotage/site1/production/tableau_bord/controller_tableau_bord/controller_tableau_bord.dart';

class BarChartEnjeu extends StatefulWidget {
  const BarChartEnjeu({super.key});

  @override
  State<BarChartEnjeu> createState() => _BarChartEnjeuState();
}

class _BarChartEnjeuState extends State<BarChartEnjeu> {


  final ControllerTableauBord controllerTableauBord = Get.find();
  List<dynamic> MesDonnees=[];
  @override
  void initState() {
    MesDonnees=controllerTableauBord.getPerformance()[1];
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1200,
      height: 200,
      child:  DChartBarO(
        vertical:false,
        animate:true,
        groupList: [
          OrdinalGroup(id:"1",
              color:Colors.blue,
              data:List.generate(MesDonnees.length,
                      (index) => OrdinalData(domain:MesDonnees[index]["enjeu"]??"" , measure:MesDonnees[index]["perf"]??1))

          )
        ],
      ),
    );
  }
}
