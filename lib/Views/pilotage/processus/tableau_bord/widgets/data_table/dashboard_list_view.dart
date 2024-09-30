import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:perfqse/common.dart';
import '../../controller_tableau_bord/controller_tableau_bord.dart';
import 'row_axe.dart';

class DashBoardListView extends StatefulWidget {
  const DashBoardListView({Key? key}) : super(key: key);

  @override
  State<DashBoardListView> createState() => _DashBoardListViewState();
}

class _DashBoardListViewState extends State<DashBoardListView> {
  late ScrollController _scrollController;
  final ControllerTableauBord controllerTb = Get.find();
  int year=DateTime.now().year;
  final storage=FlutterSecureStorage();

  void allReset()async{
    String? espace="$Processus";// String? espace=await storage.read(key:"espace");
    controllerTb.getAllViewTableauBord(annee:year, espace:espace );
  }
  @override
  void initState() {
    super.initState();
    allReset();
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
      return
       Theme(
          data: Theme.of(context).copyWith(scrollbarTheme: ScrollbarThemeData(
            trackColor:  MaterialStateProperty.all(Colors.black12),
            trackBorderColor: MaterialStateProperty.all(Colors.black38),
            thumbColor: MaterialStateProperty.all(Colors.black),
            interactive: true,
          )),
          child: Scrollbar(
            controller: _scrollController,
            thumbVisibility: true,
            thickness: 8,
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(scrollbars: true),
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                child: Container(
                  //padding: const EdgeInsets.only(right: 10.0),
                    child: Obx(()
                      => Column(
                          children:controllerTb.axesTableauBord.toList().map((axe)=>RowAxe(title: axe.libelle, color: Colors.brown, idAxe: axe.idAxe)).toList()
                      ),
                    )
            ),
          ),
        ))
      );
  }
}