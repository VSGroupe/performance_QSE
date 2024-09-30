import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:perfqse/Views/gestion/dangers_et_incidents/widgets/incidents.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

import '../../../../constants/colors.dart';
import '../../../../models/common/user_model.dart';
import '../../../../models/pilotage/acces_pilotage_model.dart';
import '../../../../widgets/customtext.dart';
import 'widgets/export_widgets_dangers_et_incidents.dart';

class DangersEtIncidents extends StatefulWidget {

  @override
  State<DangersEtIncidents> createState() => _DangersEtIncidentsState();
}

class _DangersEtIncidentsState extends State<DangersEtIncidents> with SingleTickerProviderStateMixin {
  static const List<Tab> myTabs = <Tab>[
    Tab(text: 'Dangers'),
    Tab(text: 'Incidents'),
    Tab(text: 'Ajout d\'un incident ou d\'un danger'),
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
                    labelPadding:
                    const EdgeInsets.only(left: 0, right: 30),
                    unselectedLabelColor: Colors.red.shade800,
                    indicator: MaterialIndicator(
                      color: Colors.red.shade800,
                      paintingStyle: PaintingStyle.fill,
                    )),
                tabs: const [
                  CustomText(
                    text: "Dangers",
                    size: 15,
                  ),
                  CustomText(
                    text: "Incidents",
                    size: 15,
                  ),
                  CustomText(
                    text: "Ajout d'un incident ou d'un danger",
                    size: 15,
                  ),
                ],
                views: [
                  Container(child: Dangers(),),
                  Container(child: Incidents(),),
                  Container(child: ModifierDangerOuIncident(),),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
