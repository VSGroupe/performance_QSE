import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:perfqse/Views/gestion/gestion_des_processus/controller/gestion_processus_controller.dart';
import 'package:perfqse/Views/gestion/gestion_des_processus/widgets/ajout_processus.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

import '../../../../constants/colors.dart';
import '../../../../models/common/user_model.dart';
import '../../../../models/pilotage/acces_pilotage_model.dart';
import '../../../../widgets/customtext.dart';
import 'widgets/export_widgets_gestion_processus.dart';
import 'package:get/get.dart';

class GestionProcessus extends StatefulWidget {

  @override
  State<GestionProcessus> createState() => _GestionProcessusState();
}

class _GestionProcessusState extends State<GestionProcessus> with SingleTickerProviderStateMixin {

  final GestionProcessusController gestionProcessusController = Get.put(GestionProcessusController());

  static const List<Tab> myTabs = <Tab>[
    Tab(text: 'Cartographie des processus'),
    Tab(text: 'Fiche d\'identité des pocessus'),
    Tab(text: 'Ajouter un processus'),
  ];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(vsync: this, length: myTabs.length, initialIndex: 0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: defaultPadding,bottom: defaultPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: SizedBox(
              width: double.maxFinite,
              child: ContainedTabBarView(
                tabBarViewProperties: const TabBarViewProperties(
                  physics: BouncingScrollPhysics(),
                  dragStartBehavior: DragStartBehavior.start,
                ),
                tabBarProperties: TabBarProperties(
                  alignment: TabBarAlignment.start,
                  isScrollable: true,
                  labelColor: Colors.black,
                  labelPadding: const EdgeInsets.only(left: 0, right: 30),
                  unselectedLabelColor: Colors.amber,
                  indicator: MaterialIndicator(
                    color: Colors.amber,
                    paintingStyle: PaintingStyle.fill,
                  ),
                ),
                tabs: () {
                  if (gestionProcessusController.aAfficher.value == 1) {
                    return const [
                      CustomText(text: "Cartographie des processus", size: 15),
                      CustomText(text: "Fiche d'identité des pocessus", size: 15),
                      CustomText(text: "Ajouter un processus", size: 15),
                    ];
                  } else {
                    return const [
                      CustomText(text: "Fiche d'identité des pocessus", size: 15),
                      CustomText(text: "Cartographie des processus", size: 15),
                      CustomText(text: "Ajouter un processus", size: 15),
                    ];
                  }
                }(),
                views: () {
                  if (gestionProcessusController.aAfficher.value == 1) {
                    return [
                      Container(child: CartographieProcessus()),
                      Container(child: FicheDIdentiteProcessus()),
                      Container(child: AjoutProcessus()),
                    ];
                  } else {
                    return [
                      Container(child: FicheDIdentiteProcessus()),
                      Container(child: CartographieProcessus()),
                      Container(child: AjoutProcessus()),
                    ];
                  }
                }(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
