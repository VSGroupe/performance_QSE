import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:perfqse/Views/pilotage/processus/tableau_bord/widgets/data_table/row_indicateur.dart';
import 'package:perfqse/models/pilotage/critereModel.dart';
import '../../../../../../../models/pilotage/indicateur_row_model.dart';
import '../../controller_tableau_bord/controller_tableau_bord.dart';
import '../utils_TB.dart';
import 'row_critNormatif.dart';

class RowEnjeu extends StatefulWidget {
  final String numero;
  final String idAxe;
  final String idEnjeu;
  final String EnjeuTitle;
  final Color color;
  const RowEnjeu(
      {Key? key,
        required this.EnjeuTitle,
        required this.idEnjeu,
        required this.color,
        required this.idAxe,
        required this.numero})
      : super(key: key);

  @override
  State<RowEnjeu> createState() => _RowEnjeuState();
}

class _RowEnjeuState extends State<RowEnjeu> {
  bool _press=false;
  final ControllerTableauBord controllerTableauBord=Get.find();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 30,
          padding: const EdgeInsets.only(left: 100),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: widget.color.withOpacity(0.7),
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(4.0)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "${widget.numero}. ${widget.EnjeuTitle}",
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
              Expanded(child: Container()),
              RotatedBox(
                quarterTurns:_press ? 1 : 3,
                child: IconButton(
                  splashRadius: 10,
                  icon: const Icon(
                    Icons.arrow_back_ios_sharp,
                    size: 15,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    setState(() {
                      _press=!_press;
                    });
                  },
                ),
              ),
              const SizedBox(
                width: 15,
              )
            ],
          ),
        ),
        Visibility(
          visible: _press,
          child:Obx(()
            =>Column(
                children: getIndicateurWidget(widget.EnjeuTitle,controllerTableauBord.moisSelectFiltre.value,controllerTableauBord.indicateurRowTableauBord)
              ),
          )
        )
      ],
    );
  }
}


List<Widget> getIndicateurWidget(String EnjeuTitle,String moisSelected,List<IndicateurRowTableauBordModel>indicateurRowTableauBord){
  List<String>ListStringMois=["Janvier","Fevrier","Mars","Avril","Mai","Juin","Juillet","Aout","Septembre","Octobre","Novembre","Decembre"];
  final int intMois = DateTime.now().month;
  List<IndicateurRowTableauBordModel> containerIndicateurRowTB=indicateurRowTableauBord.where((element) =>element.critereNormatif==EnjeuTitle).toList();
  return containerIndicateurRowTB.map((indicateur) => RowIndicateur(indicateur: indicateur,mois:moisSelected,)).toList();
}


// List<Widget> getCritereNormatifWidget(String idEnjeu, List<CritereModel> criteres) {
//   List<CritereModel> critereContainer = criteres.where((element) => element.idEnjeu == idEnjeu).toList();
//   return critereContainer.map((critere) => RowCritereNormatif(
//     idEnjeu: critere.idEnjeu,
//     numero: critere.idCritere.length == 8 ? critere.idCritere.substring(7, 8) : critere.idCritere.substring(7, 9),
//     idCritNormatif: critere.idCritere,
//     CritNormatifTitle: critere.libelle,
//     color: Colors.lightBlue,
//   )).toList();
// }