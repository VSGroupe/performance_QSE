import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

import '../../../../constants/colors.dart';
import '../../../../models/common/user_model.dart';
import '../../../../models/pilotage/acces_pilotage_model.dart';
import '../../../../widgets/customtext.dart';
import 'widgets/export_widgets_perimetres_et_domaines_d_application.dart';

class PerimetresEtDomainesDApplication extends StatefulWidget {

  @override
  State<PerimetresEtDomainesDApplication> createState() => _PerimetresEtDomainesDApplicationState();
}

class _PerimetresEtDomainesDApplicationState extends State<PerimetresEtDomainesDApplication> with SingleTickerProviderStateMixin {
  static const List<Tab> myTabs = <Tab>[
    Tab(text: "Périmètre, domaines d'application"),
    Tab(text: 'Exclusions et justifications'),
    //Tab(text: 'Modifier mon mot de passe'),
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
                    text: "Périmètre, domaines d'application",
                    size: 15,
                  ),
                  CustomText(
                    text: "Exclusions et justifications",
                    size: 15,
                  ),
                  // CustomText(
                  //   text: "Modifier mon mot de passe",
                  //   size: 15,
                  // ),
                ],
                views: [
                  Container(child: DomainesDApplication(),),
                  Container(child: ExclusionsEtJustifications(),),
                  //Container(child: Password(),)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
