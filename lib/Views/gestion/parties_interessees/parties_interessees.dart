import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

import '../../../../constants/colors.dart';
import '../../../../models/common/user_model.dart';
import '../../../../models/pilotage/acces_pilotage_model.dart';
import '../../../../widgets/customtext.dart';
import 'widgets/export_widgets_parities_interessees.dart';

class PartiesInteressees extends StatefulWidget {

  @override
  State<PartiesInteressees> createState() => _PartiesInteresseesState();
}

class _PartiesInteresseesState extends State<PartiesInteressees> with SingleTickerProviderStateMixin {
  static const List<Tab> myTabs = <Tab>[
    Tab(text: 'Cartographie des parties intéressées'),
    Tab(text: 'Attentes des parties intéressées'),
    Tab(text: 'Ajouter une partie intéressées'),
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
                    text: "Cartographie des parties intéressées",
                    size: 15,
                  ),
                  CustomText(
                    text: "Attentes des parties intéressées",
                    size: 15,
                  ),
                  CustomText(
                    text: "Ajouter une partie intéressées",
                    size: 15,
                  ),
                ],
                views: [
                  Container(child: ApercuPartiesInteressees(),),
                  Container(child: AttentesPartiesInteressees(),),
                  Container(child: AjouterPartiesInteressees(),)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
