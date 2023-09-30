// import 'package:auto_animated/auto_animated.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../archive/BoxText/boxaxes.dart';
// import '../../../../../../constants/colors.dart';
// import '../../../../../../helpers/responsive.dart';
// import '../strategy_info/pilier_model.dart';
// import '../strategy_info/pilier_info_card.dart';
//
// class SectionSuivi extends StatefulWidget {
//      SectionSuivi({
//     Key? key,
//   }) : super(key: key);
//
//      @override
//      State<SectionSuivi> createState() => _SectionSuiviState();
// }
//
// class _SectionSuiviState extends State<SectionSuivi> with TickerProviderStateMixin{
//
//   dynamic AxeInfos = [
//     {
//       "firsttitle":"ALIGNEMENT",
//       "secondtitle":"STRATEGIQUE",
//       "subtitle":"n indicateur(s) sur 90",
//       "numfull":48,
//       "width_1":280,
//       "width_2":130,
//       "color":Color.fromRGBO(172,28,12,1)
//     },
//     {
//       "firsttitle":"MAITRISE",
//       "secondtitle":"OPERATIONNELLE",
//       "subtitle":"n indicateur(s) sur 100",
//       "numfull":78,
//       "width_1":310,
//       "width_2":160,
//       "color":Color.fromRGBO(172,28,12,1)
//     },
//     {
//       "firsttitle":"PERF & INTEGRITE",
//       "secondtitle":"DU SYSTEME",
//       "subtitle":"n indicateur(s) sur 90",
//       "numfull":56,
//       "width_1":320,
//       "width_2":170,
//       "color":Color.fromRGBO(172,28,12,1)
//     },
//     {
//       "firsttitle":"RESILIENCE",
//       "secondtitle":"DU SYSTEME",
//       "subtitle":"n indicateur(s) sur 200",
//       "numfull":87,
//       "width_1":280,
//       "width_2":130,
//       "color":Color.fromRGBO(172,28,12,1)
//     },
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//
//   }
//    @override
//   Widget build(BuildContext context) {
//     final Size _size = MediaQuery.of(context).size;
//
//     bool btnSelect1=false;
//     bool btnSelect2=false;
//     bool btnSelect3=false;
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               "Les Axes Stratégiques",
//               style: Theme.of(context).textTheme.titleMedium,
//             ),
//           ],
//         ),
//         SizedBox(height: defaultPadding),
//         Container(
//           width: 1200,
//           height: 100,
//           child: Column(
//             children: [
//               SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Container(
//                   width: 1200,
//                   height: 100,
//                   child: Row(
//                     children:List.generate(4, (index) =>
//                           BoxAxe(firsttitle:AxeInfos[index]["firsttitle"],
//                             secondtitle:AxeInfos[index]["secondtitle"],
//                             subtitle: AxeInfos[index]["subtitle"],
//                             color:AxeInfos[index]["color"],
//                             colorChartSectionFull: Colors.lightGreen,
//                             colorChartSectionEmpty: Colors.orange,
//                             numChartSectionFull: AxeInfos[index]["numfull"],
//                             width_1:AxeInfos[index]["width_1"], width_2: AxeInfos[index]["width_2"],)
//
//                     ),
//                 ),
//               )
//               ),
//             ],
//           ),
//         )
//       ],
//     );
//   }
// }

import 'package:auto_animated/auto_animated.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:perfqse/Views/pilotage/entity/tableau_bord/controller_tableau_bord/controller_tableau_bord.dart';
import 'package:perfqse/module/styled_scrollview.dart';
import '../../../../../../models/pilotage/indicateur_row_model.dart';
import '../../../archive/BoxText/boxaxes.dart';
import '../../../../../../constants/colors.dart';

class SectionSuivi extends StatefulWidget {
  final List<IndicateurRowTableauBordModel> indicateurRowTableauBord;
  SectionSuivi({
    Key? key, required this.indicateurRowTableauBord,
  }) : super(key: key);

     @override
     State<SectionSuivi> createState() => _SectionSuiviState();
}

class _SectionSuiviState extends State<SectionSuivi> with TickerProviderStateMixin{
  final ControllerTableauBord controllerTableauBord=Get.find();
  late  dynamic data;


  @override
  void initState() {
    super.initState();
    data=controllerTableauBord.getAlimentationSectionSuivie();
  }

   @override
  Widget build(BuildContext context) {

    final Size _size = MediaQuery.of(context).size;
    bool btnSelect1=false;
    bool btnSelect2=false;
    bool btnSelect3=false;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Les Axes Stratégiques",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        SizedBox(height: defaultPadding),
        Container(
          width: double.infinity,
          height: 100,
          child: LiveList(
            showItemInterval: Duration(milliseconds: 500),
            showItemDuration: Duration(seconds: 1),
            scrollDirection: Axis.horizontal,
            itemCount: 4,
            itemBuilder: _buildAnimatedItem,
          ),
        )
      ],
    );
  }
  Widget _buildAnimatedItem(
      BuildContext context,
      index,
      Animation<double> animation,
      ) =>
      FadeTransition(
        opacity: Tween<double>(
          begin: 0,
          end: 1,
        ).animate(animation),
        child: SlideTransition(
          position: Tween<Offset>(
            begin: Offset(0, -0.1),
            end: Offset.zero,
          ).animate(animation),
          child: _buildCard(index),
        ),
      );

  Widget _buildCard(index) {
    dynamic AxeInfos = [
      {
        "firsttitle":"ALIGNEMENT",
        "secondtitle":"STRATEGIQUE",
        "subtitle":"${data[0]["numberIndicateurValidate"]} indicateur(s) sur ${data[0]["numberIndicateur"]}",
        "numfull":data[0]["pourcentage"],
        "width_1":280,
        "width_2":130,
        "color":Color.fromRGBO(172,28,12,1)
      },
      {
        "firsttitle":"MAITRISE",
        "secondtitle":"OPERATIONNELLE",
        "subtitle":"${data[1]["numberIndicateurValidate"]} indicateur(s) sur ${data[1]["numberIndicateur"]}",
        "numfull":data[1]["pourcentage"],
        "width_1":306,
        "width_2":160,
        "color":Color.fromRGBO(172,28,12,1)
      },
      {
        "firsttitle":"PERF & INTEGRITE",
        "secondtitle":"DU SYSTEME",
        "subtitle":"${data[2]["numberIndicateurValidate"]} indicateur(s) sur ${data[2]["numberIndicateur"]}",
        "numfull":data[2]["pourcentage"],
        "width_1":310,
        "width_2":170,
        "color":Color.fromRGBO(172,28,12,1)
      },
      {
        "firsttitle":"RESILIENCE",
        "secondtitle":"DU SYSTEME",
        "subtitle":"${data[3]["numberIndicateurValidate"]} indicateur(s) sur ${data[3]["numberIndicateur"]}",
        "numfull":data[3]["pourcentage"],
        "width_1":270,
        "width_2":130,
        "color":Color.fromRGBO(172,28,12,1)
      },
    ];
    return Builder(
      builder: (context) =>
          BoxAxe(firsttitle: AxeInfos[index]["firsttitle"],
            secondtitle: AxeInfos[index]["secondtitle"],
            subtitle: AxeInfos[index]["subtitle"],
            color: AxeInfos[index]["color"],
            colorChartSectionFull: Colors.lightGreen,
            colorChartSectionEmpty: Colors.orange,
            numChartSectionFull: AxeInfos[index]["numfull"].toDouble(),
            width_1: AxeInfos[index]["width_1"].toDouble(),
            width_2: AxeInfos[index]["width_2"].toDouble(),),
    );
  }
}