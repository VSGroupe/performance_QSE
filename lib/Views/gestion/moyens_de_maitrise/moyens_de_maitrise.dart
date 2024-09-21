import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:perfqse/Views/gestion/moyens_de_maitrise/widgets/maitrise_ies.dart';
import 'package:perfqse/Views/gestion/moyens_de_maitrise/widgets/maitrise_incidents.dart';
import 'package:perfqse/Views/gestion/moyens_de_maitrise/widgets/maitrise_risques.dart';
import 'package:perfqse/Views/gestion/moyens_de_maitrise/widgets/maitrise_urgences.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import '../../../../constants/colors.dart';
import '../../../../widgets/customtext.dart';

class MoyensDeMaitrise extends StatefulWidget {

  @override
  State<MoyensDeMaitrise> createState() => _MoyensDeMaitriseState();
}

class _MoyensDeMaitriseState extends State<MoyensDeMaitrise> with SingleTickerProviderStateMixin {
  static const List<Tab> myTabs = <Tab>[
    Tab(text: 'Maîtrise des risques'),
    Tab(text: 'Maîtrise des IES'),
    Tab(text: 'Maîtrise des dangers et incidents'),
    Tab(text: 'Maîtrise des urgences'),
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
                    text: "Maîtrise des risques",
                    size: 15,
                  ),
                  CustomText(
                    text: "Maîtrise des IES",
                    size: 15,
                  ),
                  CustomText(
                    text: "Maîtrise des dangers et incidents",
                    size: 15,
                  ),
                  CustomText(
                    text: "Maîtrise des urgences",
                    size: 15,
                  ),
                ],
                views: [
                  Container(child: MaitriseRisques(),),
                  Container(child: MaitriseIes(),),
                  Container(child: MaitriseIncidents(),),
                  Container(child: MaitriseUrgences(),),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
