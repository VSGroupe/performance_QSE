import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

import '../../../../constants/colors.dart';
import '../../../../models/common/user_model.dart';
import '../../../../models/pilotage/acces_pilotage_model.dart';
import '../../../../widgets/customtext.dart';
import 'widgets/export_widgets_contexte.dart';

class Contexte extends StatefulWidget {

  @override
  State<Contexte> createState() => _ContexteState();
}

class _ContexteState extends State<Contexte> with SingleTickerProviderStateMixin {
  static const List<Tab> myTabs = <Tab>[
    Tab(text: 'Environnement de l\'entreprise'),
    Tab(text: 'Analyse du contexte'),
    Tab(text: 'Rapport du risque'),
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
                    labelPadding:
                    const EdgeInsets.only(left: 0, right: 30),
                    unselectedLabelColor: Colors.amber,
                    indicator: MaterialIndicator(
                      color: Colors.amber,
                      paintingStyle: PaintingStyle.fill,
                    )),
                tabs: const [
                  CustomText(
                    text: "Environnement de l'entreprise",
                    size: 15,
                  ),
                  CustomText(
                    text: "Analyse du contexte",
                    size: 15,
                  ),
                  CustomText(
                    text: "Rapport du risque",
                    size: 15,
                  ),
                ],
                views: [
                  Container(child: FonctionsGenerales(),),
                  Container(child: AnalyseDuContexte(),),
                  Container(child: RapportDuRisque(),),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
