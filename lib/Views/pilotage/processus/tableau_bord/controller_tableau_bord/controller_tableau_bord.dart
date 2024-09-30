import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:perfqse/models/pilotage/data_indicateur_row_model.dart';
import 'package:perfqse/models/pilotage/indicateur_model.dart';

import '../../../../../../api/supabase.dart';
import '../../../../../../models/pilotage/axeModel.dart';
import '../../../../../../models/pilotage/critereModel.dart';
import '../../../../../../models/pilotage/enjeuModel.dart';
import '../../../../../../models/pilotage/indicateur_row_model.dart';
import '../../../../../common.dart';

class ControllerTableauBord extends GetxController{
  int annee =DateTime.now().year;
  final storage =FlutterSecureStorage();
  final DataBaseController dbController= DataBaseController();
  var centerCicle="".obs;
  var moisSelectFiltre="".obs;
  var anneeSelectFiltre=1.obs;
  var axeSelected="".obs;
  var dataOverviewSuivie=[{}].obs;
  List<AxeModel> axes=<AxeModel>[].obs;
  List<EnjeuModel>enjeux=<EnjeuModel>[].obs;
  List<CritereModel>criteres=<CritereModel>[].obs;
  var axesTableauBord=<AxeModel>[].obs;
  var enjeuxTableauBord=<EnjeuModel>[].obs;
  List<IndicateurModel>indicateurs=<IndicateurModel>[].obs;
  var criteresTableauBord=<CritereModel>[].obs;
  List<DataIndicateurRowModel>dataIndicateurRow=<DataIndicateurRowModel>[].obs;
  var indicateurRowTableauBord=<IndicateurRowTableauBordModel>[].obs;
  List<IndicateurRowTableauBordModel>containerUpdateIndicateurRow=<IndicateurRowTableauBordModel>[].obs;
  final moisString=["Janvier","Fevrier","Mars","Avril","Mai","Juin","Juillet","Aout","Septembre","Octobre","Novembre","Decembre"];
  final moisInt=DateTime.now().month;


  void getIndicateur()async{
    indicateurs=await dbController.getAllIndicateur();
  }
  void getAxes()async{
    axes=await dbController.getAllAxe();
    axesTableauBord.value=axes;

  }
  void getCritere()async{
    criteres=await dbController.getAllCritere();
    criteresTableauBord.value=criteres;
  }

  void getEnjeu()async{
    enjeux=await dbController.getAllEnjeu();
    enjeux.toList().sort((a,b)=>a.idEnjeu.compareTo(b.idEnjeu));
    enjeuxTableauBord.value=enjeux;
  }
  // Mettre au niveau de l'OverviewPage/l'SuiviPage/PerformancePage/
  void getDataIndicateurRow({required annee,required espace})async{
    dataIndicateurRow.addAll(await dbController.getAllDataRowIndicateur(espace,annee));
  }
  // Mettre au niveau de l'OverviewPage/l'SuiviPage/PerformancePage/
  void assemblyIndicateurWithDataIndicateur()async{
    String?  espace = Processus;
    indicateurRowTableauBord.value=await dbController.getIndicateurWithDataIndicateur(espace!, annee);
    getAxes();
    getCritere();
    getEnjeu();
  }
  // Mettre au niveau de la commonMainPage/outils de renitialisation des paramettre du tableau de bord
  void getAllViewTableauBord({required annee,required espace})async{
    anneeSelectFiltre.value=annee;
    moisSelectFiltre.value=moisString[moisInt];
    indicateurRowTableauBord.value=await dbController.getIndicateurWithDataIndicateur(espace, annee);
    getAxes();
    getCritere();
    getEnjeu();
  }

  void disableFilter(){
    anneeSelectFiltre.value=annee;
    moisSelectFiltre.value=moisString[moisInt];
    axesTableauBord.value=axes;
  }

  List<Map<dynamic,dynamic>>getAlimentationSectionSuivie() {
    dynamic data = [{}];
    assemblyIndicateurWithDataIndicateur();
    List<IndicateurRowTableauBordModel> IndicateursAxe1 = indicateurRowTableauBord.toList().where((element) => element.axe == "axe1").toList();
    List<IndicateurRowTableauBordModel> IndicateursAxe2 = indicateurRowTableauBord.toList().where((element) => element.axe == "axe2").toList();
    List<IndicateurRowTableauBordModel> IndicateursAxe3 = indicateurRowTableauBord.toList().where((element) => element.axe == "axe3").toList();
    List<IndicateurRowTableauBordModel> IndicateursAxe4 = indicateurRowTableauBord.toList().where((element) => element.axe == "axe4").toList();

    int numberIndicateurValidateAxe1 = IndicateursAxe1.where((element) => element.realisee.isValidate == 1).toList().length;
    int numberIndicateurValidateAxe2 = IndicateursAxe2.where((element) => element.realisee.isValidate == 1).toList().length;
    int numberIndicateurValidateAxe3 = IndicateursAxe3.where((element) => element.realisee.isValidate == 1).toList().length;
    int numberIndicateurValidateAxe4 = IndicateursAxe4.where((element) => element.realisee.isValidate == 1).toList().length;

    List<int>listOfNumberIndicateurValidate = [
      numberIndicateurValidateAxe1,
      numberIndicateurValidateAxe2,
      numberIndicateurValidateAxe3,
      numberIndicateurValidateAxe4
    ];
    print(listOfNumberIndicateurValidate);

    int numberIndicateurAxe1 = IndicateursAxe1.length;
    int numberIndicateurAxe2 = IndicateursAxe2.length;
    int numberIndicateurAxe3 = IndicateursAxe3.length;
    int numberIndicateurAxe4 = IndicateursAxe4.length;

    List<int>listOfNumberIndicateur = [
      numberIndicateurAxe1,
      numberIndicateurAxe2,
      numberIndicateurAxe3,
      numberIndicateurAxe4
    ];
    print(listOfNumberIndicateur);
    data =[
    {
      "axe": "axe1",
      "numberIndicateur": listOfNumberIndicateur[0],
      "numberIndicateurValidate": listOfNumberIndicateurValidate[0],
      "pourcentage": (listOfNumberIndicateurValidate[0] / listOfNumberIndicateur[0]) * 100
    },
      {
        "axe": "axe2",
        "numberIndicateur": listOfNumberIndicateur[1],
        "numberIndicateurValidate": listOfNumberIndicateurValidate[1],
        "pourcentage": (listOfNumberIndicateurValidate[1] / listOfNumberIndicateur[1]) * 100
      },
      {
        "axe": "axe3",
        "numberIndicateur": listOfNumberIndicateur[2],
        "numberIndicateurValidate": listOfNumberIndicateurValidate[2],
        "pourcentage": (listOfNumberIndicateurValidate[2] / listOfNumberIndicateur[2]) * 100
      },
      {
        "axe": "axe4",
        "numberIndicateur": listOfNumberIndicateur[3],
        "numberIndicateurValidate": listOfNumberIndicateurValidate[3],
        "pourcentage": (listOfNumberIndicateurValidate[3] / listOfNumberIndicateur[3]) * 100
      }
    ];
    return data;
  }


  List<dynamic>getPerformance() {
    dynamic data = [];
    List<Map<String,dynamic>> numberIndCritereValidate=[{}];
    List<Map<String,dynamic>> numberIndEnjeuValidate=[{}];
    assemblyIndicateurWithDataIndicateur();
    List<IndicateurRowTableauBordModel> IndicateursAxe1 = indicateurRowTableauBord.toList().where((element) => element.axe == "axe1").toList();
    List<IndicateurRowTableauBordModel> IndicateursAxe2 = indicateurRowTableauBord.toList().where((element) => element.axe == "axe2").toList();
    List<IndicateurRowTableauBordModel> IndicateursAxe3 = indicateurRowTableauBord.toList().where((element) => element.axe == "axe3").toList();
    List<IndicateurRowTableauBordModel> IndicateursAxe4 = indicateurRowTableauBord.toList().where((element) => element.axe == "axe4").toList();


    int numberIndicateurValidateAxe1 = IndicateursAxe1.where((element) => element.realisee.isValidate == 1).toList().length;
    int numberIndicateurValidateAxe2 = IndicateursAxe2.where((element) => element.realisee.isValidate == 1).toList().length;
    int numberIndicateurValidateAxe3 = IndicateursAxe3.where((element) => element.realisee.isValidate == 1).toList().length;
    int numberIndicateurValidateAxe4 = IndicateursAxe4.where((element) => element.realisee.isValidate == 1).toList().length;


    criteres.forEach((critere) {
      int Donnee=0;
      int TotalIndCrit=0;
      indicateurRowTableauBord.toList().forEach((indicateur) {
        if(indicateur.critereNormatif==critere.libelle){
          TotalIndCrit+=1;
          if(indicateur.realisee.isValidate==1){
            Donnee+=1;
          }
        }
      }) ;
      numberIndCritereValidate.add({"critere":critere.libelle,"perf":(Donnee/TotalIndCrit)*100});

    });


    enjeux.forEach((enjeu) {
      int Donnee=0;
      int TotalIndEnj=0;
      indicateurRowTableauBord.toList().forEach((indicateur) {
        if(indicateur.enjeu==enjeu.libelle){
          TotalIndEnj+=1;
          if(indicateur.realisee.isValidate==1){
            Donnee+=1;
          }
        }
      }) ;
      numberIndEnjeuValidate.add({"enjeu":enjeu.libelle,"perf":(Donnee/TotalIndEnj)*100});
    });
    print("$numberIndCritereValidate + $numberIndCritereValidate");
  return [numberIndCritereValidate,numberIndEnjeuValidate];
  }





  void doFilter({required annee,required espace,required mois,required axe,required critere,required enjeu})async{
    indicateurRowTableauBord.value=await dbController.getIndicateurWithDataIndicateur(espace, annee);
    if(axe?.isNotEmpty){
      axesTableauBord.value = axes
          .where((elem1) => axe.any((elem2)=>elem2.idAxe==elem1.idAxe))
          .map((element) =>AxeModel(idAxe:element.idAxe, libelle:element.libelle))
          .toList();
    }
    if(critere?.isNotEmpty){
      criteresTableauBord.value = criteres
          .where((elem1) => critere.any((elem2)=>elem2.idCritere==elem1.idCritere))
          .map((element) => CritereModel(idEnjeu:element.idEnjeu,idCritere: element.idCritere, libelle: element.libelle))
          .toList();
    }
    if(enjeu?.isNotEmpty){
      enjeuxTableauBord.value = enjeux
          .where((elem1) => enjeu.any((elem2)=>elem2.idEnjeu==elem1.idEnjeu))
          .map((element) =>EnjeuModel(idAxe:element.idAxe , idEnjeu:element.idEnjeu, libelle:element.libelle))
          .toList();
    }

  }

  void updateDataBase(List<IndicateurRowTableauBordModel> dataIndicateur)async{
    try {
      dataIndicateur.forEach((data) async {
        print(data);
        await dbController.updateDataIndicateur(data);
      });
    }on Exception catch(e){
      throw(e);
    }
  }

  @override
  void onInit() {
    axeSelected.value="MANAGEMENT DU QSE";
    anneeSelectFiltre.value=annee;
    moisSelectFiltre.value=moisString[moisInt];
    super.onInit();
  }

}