import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:go_router/go_router.dart';
import 'package:perfqse/Views/pilotage/site1/commercial/tableau_bord/controller_tableau_bord/com_controller_tableau_bord.dart';
import '../../../../../../../models/pilotage/indicateur_row_model.dart';
import '../utils_TB.dart';

class DashBoardUtils{

  static bool editDataRow (BuildContext context,IndicateurRowTableauBordModel indicator,num? value,String mois){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Mettre à jour l'indicateur"),
          contentPadding: const EdgeInsets.all(30),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          titlePadding: const EdgeInsets.only(top: 20,right: 20,left: 20),
          titleTextStyle: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis),
          content: ContentEdition(indicator: indicator,value: value,mois:mois),
        );
      },);
    /*Get.defaultDialog(
        title: "Mettre à jour l'indicateur",
        //textAlign: TextAlign.start,
        radius: 10,
        middleTextStyle: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis),
        contentPadding: const EdgeInsets.all(30),
        titlePadding: const EdgeInsets.only(top: 20,right: 20,left: 20),
        titleStyle: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis),
        content: ContentEdition(indicator: indicator,value: value,mois:mois),
    );*/
    return true;
  }
}


class ContentEdition extends StatefulWidget {
  final IndicateurRowTableauBordModel indicator;
  final num? value;
  final String mois;
  const ContentEdition({Key? key, this.value, required this.indicator, required this.mois}) : super(key: key);

  @override
  State<ContentEdition> createState() => _ContentEditionState();
}

class _ContentEditionState extends State<ContentEdition> {
  final ComControllerTableauBord controllerTableauBord=Get.find();
  final _keyForm  = GlobalKey<FormState>();
  final TextEditingController valueController = TextEditingController();
  late bool onLoading;
  int resultEdition = 0 ;




  @override
  void initState() {
    onLoading = false;
    valueController.text = widget.value !=null ? "${widget.value}" : "";
    resultEdition = 0 ;
    super.initState();
  }

  Widget resultUI(){
    if (onLoading == true){
      return const Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Center(child: CircularProgressIndicator(color: Colors.blue,)),
      );
    }else{
      switch (resultEdition){
        case 0 :
          return Container();
        case -1 :
          return Padding(
            padding: const EdgeInsets.only(top:8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.dangerous,color: Colors.red,),
                SizedBox(width: 20,),
                Text("Echec lors de l'édition")
              ],
            ),
          );
        case 1 :
          return  Container();
        default :
          return Container();
      };
    }
  }


  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: 350,
      height:onLoading?205:180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 350,
            child: Text("${widget.indicator.intitule} (${widget.indicator.unite})",
              style: const TextStyle(fontSize: 15,fontStyle: FontStyle.italic),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          const SizedBox(height: 20,),
          Form(
            key: _keyForm,
            child: TextFormField(
              controller: valueController,
              validator: (val) => GetUtils.isNum("$val")  ? null : "Erreur de saisie",
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
          ),
          resultUI(),
          const SizedBox(height: 8.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                child: const Text('Annuler'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              ElevatedButton(
                child: const Text('Valider'),
                onPressed: onLoading == true ? null : () async {
                  if ( _keyForm.currentState!.validate() ){
                    setState(()  {
                      for (int i=0;i<controllerTableauBord.indicateurRowTableauBord.toList().length;i++){
                        if(controllerTableauBord.indicateurRowTableauBord.toList()[i].idIndicateur==widget.indicator.idIndicateur){
                           switch(widget.mois){
                             case "Janvier":
                               controllerTableauBord.indicateurRowTableauBord.toList()[i].janvier.value=int.parse(valueController.text);
                               controllerTableauBord.containerUpdateIndicateurRow.add(controllerTableauBord.indicateurRowTableauBord[i]);
                             case "Février":
                               controllerTableauBord.indicateurRowTableauBord.toList()[i].fevrier.value=int.parse(valueController.text);
                               controllerTableauBord.containerUpdateIndicateurRow.add(controllerTableauBord.indicateurRowTableauBord[i]);
                             case "Mars":
                               controllerTableauBord.indicateurRowTableauBord.toList()[i].mars.value=int.parse(valueController.text);
                               controllerTableauBord.containerUpdateIndicateurRow.add(controllerTableauBord.indicateurRowTableauBord[i]);
                             case "Avril":
                               controllerTableauBord.indicateurRowTableauBord.toList()[i].avril.value=int.parse(valueController.text);
                               controllerTableauBord.containerUpdateIndicateurRow.add(controllerTableauBord.indicateurRowTableauBord[i]);
                             case "Mai":
                               controllerTableauBord.indicateurRowTableauBord.toList()[i].mai.value=int.parse(valueController.text);
                               controllerTableauBord.containerUpdateIndicateurRow.add(controllerTableauBord.indicateurRowTableauBord[i]);
                             case "Juin":
                               controllerTableauBord.indicateurRowTableauBord.toList()[i].juin.value=int.parse(valueController.text);
                               controllerTableauBord.containerUpdateIndicateurRow.add(controllerTableauBord.indicateurRowTableauBord[i]);
                             case "Juillet":
                               controllerTableauBord.indicateurRowTableauBord.toList()[i].juillet.value=int.parse(valueController.text);
                               controllerTableauBord.containerUpdateIndicateurRow.add(controllerTableauBord.indicateurRowTableauBord[i]);
                             case "Aout":
                               controllerTableauBord.indicateurRowTableauBord.toList()[i].aout.value=int.parse(valueController.text);
                               controllerTableauBord.containerUpdateIndicateurRow.add(controllerTableauBord.indicateurRowTableauBord[i]);
                             case "Septembre":
                               controllerTableauBord.indicateurRowTableauBord.toList()[i].septembre.value=int.parse(valueController.text);
                               controllerTableauBord.containerUpdateIndicateurRow.add(controllerTableauBord.indicateurRowTableauBord[i]);
                             case "Octobre":
                               controllerTableauBord.indicateurRowTableauBord.toList()[i].octobre.value=int.parse(valueController.text);
                               controllerTableauBord.containerUpdateIndicateurRow.add(controllerTableauBord.indicateurRowTableauBord[i]);
                             case "Novembre":
                               controllerTableauBord.indicateurRowTableauBord.toList()[i].novembre.value=int.parse(valueController.text);
                               controllerTableauBord.containerUpdateIndicateurRow.add(controllerTableauBord.indicateurRowTableauBord[i]);
                             case "Decembre":
                               controllerTableauBord.indicateurRowTableauBord.toList()[i].decembre.value=int.parse(valueController.text);
                               controllerTableauBord.containerUpdateIndicateurRow.add(controllerTableauBord.indicateurRowTableauBord[i]);
                           }
                        }
                      }
                      Navigator.of(context).pop();
                    });

                  }
                }
              )
            ],
          )
        ],
      ),
    );
  }

  String getIdDoc(String idIndicateur,String entityAbr,String annee){
    final id = "${entityAbr}_${annee}_${idIndicateur}";
    return id;
  }
}

