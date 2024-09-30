import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../models/pilotage/indicateur_model.dart';
import '../../../../../../../models/pilotage/indicateur_row_model.dart';
import '../../controller_tableau_bord/controller_tableau_bord.dart';
import '../utils_TB.dart';
import 'row_indicateur.dart';

class RowCritereNormatif extends StatefulWidget {
  final String? numero;
  final String idEnjeu;
  final String idCritNormatif;
  final String CritNormatifTitle;
  final Color color;
  const RowCritereNormatif(
      {Key? key,
        required this.CritNormatifTitle,
        required this.idEnjeu,
        required this.idCritNormatif,
        required this.color,
         this.numero})
      : super(key: key);

  @override
  State<RowCritereNormatif> createState() => _RowCritereNormatifState();
}

class _RowCritereNormatifState extends State<RowCritereNormatif> {
bool _press=false;
final ControllerTableauBord controllerTableauBord=Get.find();
late final IndicateurModel indicateur;

@override
  void initState() {

    super.initState();
  }
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
                "${widget.numero}. ${widget.CritNormatifTitle}",
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
              Expanded(child: Container()),
              RotatedBox(
                quarterTurns: _press ? 1 : 3,
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
          child: Obx(()
            => Column(
                children: getIndicateurWidget(widget.CritNormatifTitle,controllerTableauBord.moisSelectFiltre.value,controllerTableauBord.indicateurRowTableauBord)
            ),
          )
        )
      ],
    );
  }
}


List<Widget> getIndicateurWidget(String CritNormatifTitle,String moisSelected,List<IndicateurRowTableauBordModel>indicateurRowTableauBord){
  List<String>ListStringMois=["Janvier","Fevrier","Mars","Avril","Mai","Juin","Juillet","Aout","Septembre","Octobre","Novembre","Decembre"];
  final int intMois = DateTime.now().month;
  List<IndicateurRowTableauBordModel> containerIndicateurRowTB=indicateurRowTableauBord.where((element) =>element.critereNormatif==CritNormatifTitle).toList();
  return containerIndicateurRowTB.map((indicateur) => RowIndicateur(indicateur: indicateur,mois:moisSelected,)).toList();
}