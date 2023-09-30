import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:perfqse/Views/pilotage/entity/tableau_bord/widgets/data_table/row_enjeu.dart';
import '../../../../../../models/pilotage/enjeuModel.dart';
import '../../../../controllers/tableau_controller.dart';
import '../../controller_tableau_bord/controller_tableau_bord.dart';
import '../utils_TB.dart';
import '/models/pilotage/indicateur_model.dart';
import 'row_critNormatif.dart';
import 'row_indicateur.dart';

class RowAxe extends StatefulWidget {
  final String idAxe;
  final String title;
  final Color color;
  const RowAxe({Key? key, required this.title, required this.color, required this.idAxe}) : super(key: key);

  @override
  State<RowAxe> createState() => _RowAxeState();
}

class _RowAxeState extends State<RowAxe> {
  final ControllerTableauBord controllerTableauBord = Get.find();
  bool _press = false;
  var listIconData = {
    "axe1": Icons.manage_accounts, "axe2": Icons.money,
    "axe3": Iconsax.people, "axe4": Iconsax.tree,
  };


  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.zero,
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: widget.color, width: 2.0),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4.0),
                    topRight: Radius.circular(4.0)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 4, bottom: 4, right: 14, left: 20),
                child: Row(
                  children: [
                    Icon(listIconData[widget.idAxe], color: widget.color,
                      size: 24,),
                    SizedBox(width: 20,),
                    Text(widget.title, style: TextStyle(color: widget.color,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),),
                    Expanded(child: Container()),
                    RotatedBox(
                      quarterTurns: _press ? 1 : 3,
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_sharp, color: Colors.black,),
                        splashRadius: 20,
                        onPressed: () {
                          setState(() {
                            _press = !_press;
                          });
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
            Visibility(
              visible: _press, //widget.dropDownState["value"],
              child: Obx(()
                => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: getEnjeuWidget(
                        widget.idAxe, controllerTableauBord.enjeuxTableauBord.toList())
                ),
              ),
            )
          ],
        )
    );
  }


  // List<Widget> getAxeSubWidget(String idAxe,String Enjeu  ){
  //   List<EnjeuModel> containEnjeu=[];
  //     for (int i = 0; i < DataEnjeu.length; i++) {
  //       if (DataEnjeu[i].idAxe == idAxe) {
  //         if (Enjeu!=""){
  //           containEnjeu.add(DataEnjeu[i]);
  //           break;
  //         }
  //         else{
  //           containEnjeu.add(DataEnjeu[i]);
  //         }
  //       }
  //     }
  //     return containEnjeu.map((enjeu) =>
  //         RowEnjeu(numero: "${enjeu.idEnjeu.substring(4, 5)}",
  //           idAxe: enjeu.idAxe,
  //           idEnjeu: enjeu.idEnjeu,
  //           EnjeuTitle: enjeu.libelle,
  //           color: widget.color,)).toList();
  // }

  List<Widget> getEnjeuWidget(String idAxe, List<EnjeuModel> enjeux) {
    List<EnjeuModel> enjeuContainer = enjeux.where((element) =>
    element.idAxe == idAxe).toList();
    return enjeuContainer.map((enjeu) => RowEnjeu(EnjeuTitle: enjeu.libelle,
        idEnjeu: enjeu.idEnjeu,
        color: widget.color,
        idAxe: enjeu.idAxe,
        numero: enjeu.idEnjeu.length==6?enjeu.idEnjeu.substring(5, 6):enjeu.idEnjeu.substring(5, 7))).toList();
  }
}
