import 'package:flutter/material.dart';
import 'package:perfqse/Views/pilotage/site1/production/performs/widgets/bar_chart_enjeu.dart';
import 'package:styled_widget/styled_widget.dart';
import '../../../../../constants/colors.dart';
import '../../../../../module/styled_scrollview.dart';
import 'widgets/bar_chart_critere.dart';
import 'widgets/entete_performance.dart';
import 'widgets/perform_enjeu/perform_enjeu.dart';
import 'widgets/perform_global/performance_global.dart';
import 'widgets/perform_pilier/performance_piliers.dart';

class PerformPilotage extends StatefulWidget {
  const PerformPilotage({Key? key}) : super(key: key);

  @override
  State<PerformPilotage> createState() => _PerformPilotageState();
}

class _PerformPilotageState extends State<PerformPilotage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: defaultPadding,bottom: defaultPadding,top: 5),
      child: StyledScrollView(
        child: Column(
          children: [
            // Text("PERFORMANCE SUIVANT LES CRITERES",style:TextStyle(
            //   fontWeight: FontWeight.bold,fontSize: 16,
            // ),),
            // SizedBox(height: 10,),
            // BarChartCritere(),
            SizedBox(height: 20,),
            Text("PERFORMANCE SUIVANT LES ENJEUX",style:TextStyle(
              fontWeight: FontWeight.bold,fontSize: 16,
            ),),
            SizedBox(height: 10,),
            BarChartEnjeu(),
          ],
        ),
      ),
    );
  }
}
