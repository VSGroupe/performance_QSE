import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:perfqse/models/pilotage/data_indicateur_row_model.dart';
import 'package:perfqse/models/pilotage/indicateur_model.dart';

import '../../../../../api/supabase.dart';
import '../../../../../models/pilotage/axeModel.dart';
import '../../../../../models/pilotage/critereModel.dart';
import '../../../../../models/pilotage/enjeuModel.dart';
import '../../../../../models/pilotage/indicateur_row_model.dart';

class ControllerTableauBord extends GetxController{
  final storage =FlutterSecureStorage();
  final DataBaseController dbController= DataBaseController();
  var centerCicle="".obs;
  List<IndicateurModel>indicateurs=<IndicateurModel>[].obs;
  List<AxeModel>axes=<AxeModel>[].obs;
  List<EnjeuModel>enjeux=<EnjeuModel>[].obs;
  List<CritereModel>criteres=<CritereModel>[].obs;
  List<AxeModel>axesTableauBord=<AxeModel>[].obs;
  List<EnjeuModel>enjeuxTableauBord=<EnjeuModel>[].obs;
  List<CritereModel>criteresTableauBord=<CritereModel>[].obs;
  List<DataIndicateurRowModel>dataIndicateurRow=<DataIndicateurRowModel>[].obs;
  List<IndicateurRowTableauBordModel>indicateurRowTableauBord=<IndicateurRowTableauBordModel>[].obs;

  void getIndicateur()async{
    indicateurs.addAll(await dbController.getAllIndicateur());
  }
  void getAxes()async{
    axes.addAll(await dbController.getAllAxe());
    axesTableauBord=axes;
  }
  void getCritere()async{
    criteres.addAll(await dbController.getAllCritere());
    criteresTableauBord=criteres;
  }
  void getEnjeu()async{
    enjeux.addAll(await dbController.getAllEnjeu());
    enjeuxTableauBord=enjeux;
  }
  // Mettre au niveau de l'OverviewPage/l'SuiviPage/PerformancePage/
  void getDataIndicateurRow({required annee,required espace})async{
    dataIndicateurRow.addAll(await dbController.getAllDataRowIndicateur(espace,annee));
  }
  // Mettre au niveau de l'OverviewPage/l'SuiviPage/PerformancePage/
  void assemblyIndicateurWithDataIndicateur()async{
    String?  espace=await storage.read(key:"espace");
    int annee =DateTime.now().year;
    indicateurRowTableauBord.addAll(await dbController.getIndicateurWithDataIndicateur(espace!, annee));
  }
  // Mettre au niveau de la commonMainPage/outils de renitialisation des paramettre du tableau de bord
  void getAllViewTableauBord({required annee,required espace})async{
    indicateurRowTableauBord.addAll(await dbController.getIndicateurWithDataIndicateur(espace, annee));
    getAxes();
    getCritere();
    getEnjeu();
  }

  void doFilter({required annee,required espace,required mois,required axe,required critere,required enjeu})async{
    indicateurRowTableauBord.addAll(await dbController.getIndicateurWithDataIndicateur(espace, annee));
    criteresTableauBord = criteres
        .where((element) => critere.contains(element.idCritere))
        .map((element) => CritereModel(idEnjeu:element.idEnjeu,idCritere: element.idCritere, libelle: element.libelle))
        .toList();
    axesTableauBord = axes
        .where((element) => axe.contains(element.idAxe))
        .map((element) =>AxeModel(idAxe:element.idAxe, libelle:element.libelle))
        .toList();
    enjeuxTableauBord = enjeux
        .where((element) => enjeu.contains(element.idEnjeu))
        .map((element) =>EnjeuModel(idAxe:element.idAxe , idEnjeu:element.idEnjeu, libelle:element.libelle))
        .toList();


  }

}