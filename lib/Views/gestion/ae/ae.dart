import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

import '../../../../constants/colors.dart';
import '../../../../models/common/user_model.dart';
import '../../../../models/pilotage/acces_pilotage_model.dart';
import '../../../../widgets/customtext.dart';
import 'widgets/export_widgets_ae.dart';
import 'package:get/get.dart';
import 'package:perfqse/Views/gestion/ae/controller/ae_controller.dart';

class Ae extends StatefulWidget {

  @override
  State<Ae> createState() => _AeState();
}

class _AeState extends State<Ae> with SingleTickerProviderStateMixin {
  final AeController aeController = Get.put(AeController());
  static const List<Tab> myTabs = <Tab>[
    Tab(text: 'aperçu'),
    // Tab(text: 'Modifier'),
    Tab(text: 'Ajouter'),
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
                  if (aeController.aAfficher.value == 1) {
                    return const [
                      CustomText(text: "Aperçu", size: 15),
                      // CustomText(text: "Modifier", size: 15),
                      CustomText(text: "Ajouter", size: 15),
                    ];
                  } else {
                    return const [
                      CustomText(text: "Ajouter", size: 15),
                      CustomText(text: "Aperçu", size: 15),
                      // CustomText(text: "Modifier", size: 15),
                    ];
                  }
                }(),
                views: () {
                  if (aeController.aAfficher.value == 1) {
                    return [
                      Container(child: Apercu()),
                      // Container(child: Modifier()),
                      Container(child: Ajouter()),
                    ];
                  } else {
                    return [
                      Container(child: Ajouter()),
                      Container(child: Apercu()),
                      // Container(child: Modifier()),
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
