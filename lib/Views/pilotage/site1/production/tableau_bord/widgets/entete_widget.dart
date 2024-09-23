import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:easy_container/easy_container.dart';
import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:perfqse/Views/pilotage/entity/tableau_bord/controller_tableau_bord/controller_tableau_bord.dart';
import 'package:perfqse/Views/pilotage/entity/tableau_bord/widgets/processus.dart';
import 'package:selector_wheel/selector_wheel/models/selector_wheel_value.dart';
import 'package:selector_wheel/selector_wheel/selector_wheel.dart';
import 'package:stylish_dialog/stylish_dialog.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax/iconsax.dart';
import 'package:perfqse/Views/pilotage/entity/tableau_bord/widgets/utils_TB.dart';

import '../../../../../../helpers/helper_methods.dart';
import '../../../../../../models/pilotage/axeModel.dart';
import '../../../../../../models/pilotage/critereModel.dart';
import '../../../../../../models/pilotage/enjeuModel.dart';
import '../../../../../../widgets/customtext.dart';

class EnteteTableauBord extends StatefulWidget {
  const EnteteTableauBord({Key? key}) : super(key: key);

  @override
  State<EnteteTableauBord> createState() => _EntityWidgetWidgetState();
}

class _EntityWidgetWidgetState extends State<EnteteTableauBord> {
  final storage =FlutterSecureStorage();
  final Location="/pilotage/espace/Bouafle/tableau-de-bord/transite-tableau-bord/indicateurs";
  int year = DateTime.now().year;
  final ControllerTableauBord controllerTb=Get.find();
  late TextEditingController mois_controller = TextEditingController();
  List<ProcessM>ProcessEntity=
  [
    ProcessM("ACHATS"),
    ProcessM("RH"),
    ProcessM("QSE"),
    ProcessM("MAINTENANCE"),
    ProcessM("LOG"),
    ProcessM("FABRICATION"),
    ProcessM("CONTROLE QUALITE"),
    ProcessM("CONDITIONNEMENT"),
  ];



  void updateIndic(BuildContext context)async{
    try{
      StylishDialog dialog1 = StylishDialog(
        context: context,
        alertType: StylishDialogType.PROGRESS,
        style: DefaultStyle(),
        controller: _controller,
        title: Text('Sauvegarde'),
      );
      //show stylish dialog
      dialog1.show();
      controllerTb.updateDataBase(controllerTb.containerUpdateIndicateurRow);
      await Future.delayed(Duration(seconds: 2));
      dialog1.dismiss();
    }on Exception catch (e){
      final message = e.toString().split("Exception: ").join("");
      await Future.delayed(Duration(seconds: 2));
      ScaffoldMessenger.of(context).showSnackBar(showSnackBar("Echec",message,Colors.red));
    }
  }
  DialogController _controller = DialogController(
    listener: (status) {
      if (status == DialogStatus.Showing) {
        debugPrint("Dialog is showing");
      } else if (status == DialogStatus.Changed) {
        debugPrint("Dialog type changed");
      } else if (status == DialogStatus.Dismissed) {
        debugPrint("Dialog dismissed");
      }
    },
  );

  List<String> tb_elem=[
    "Critères","Enjeux","Axes"
  ];
  List<CritereModel>? selectedCritereList = [];
  List<EnjeuModel>? selectedEnjeuList = [];
  List<AxeModel>? selectedAxeList = [];
  List<ProcessM>? selectedProcessList = [];

  late List<EnjeuModel>DataEnj;
  late List<CritereModel>DataCrit;
  late List<AxeModel>DataAx;

  @override
  void initState() {
    mois_controller=TextEditingController();
    DataAx=controllerTb.axes;
    DataCrit=controllerTb.criteres;
    DataEnj=controllerTb.enjeux;
    super.initState();
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    // void _openTabbedDialog(BuildContext context) {
    //   showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return TabbedDialog();
    //     },
    //   );
    // }
    return  Container(
        alignment: Alignment.bottomRight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Annee",style:TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 18
                )),
                SizedBox(height:2,),
                PopupMenuButton(
                    itemBuilder:(context){
                      return [
                        PopupMenuItem(
                            onTap: ()async{
                              setState(() {
                                controllerTb.anneeSelectFiltre.value=year-2;
                              });
                              final storage=FlutterSecureStorage();
                              final String? espace=await storage.read(key:"espace");
                                controllerTb.getAllViewTableauBord(annee:controllerTb.anneeSelectFiltre.value , espace: espace);
                                if(controllerTb.indicateurRowTableauBord.isEmpty){
                                  ScaffoldMessenger.of(context).showSnackBar(showSnackBar("Erreur"
                                      ,"Les données n'existes pas", Colors.red));
                                }else{
                                  ScaffoldMessenger.of(context).showSnackBar(showSnackBar("Succès"
                                      ,"Chargement effectué", Colors.green));
                                }
                              },
                            child:Text("${year-2}")),
                        PopupMenuItem(
                            onTap: () async {
                              setState(() {
                                controllerTb.anneeSelectFiltre.value=year-1;
                              });
                              final storage=FlutterSecureStorage();
                              final String? espace=await storage.read(key:"espace");
                              try{
                                controllerTb.getAllViewTableauBord(annee: controllerTb.anneeSelectFiltre.value, espace:espace);
                              }on Exception catch(e){
                                ScaffoldMessenger.of(context).showSnackBar(showSnackBar("Erreur"
                                    ,"Un Problème est survenue lors du chargement des données", Colors.green));
                              }
                              },
                            child:Text("${year-1}")),
                        PopupMenuItem(
                            onTap: () async {
                              setState(() {
                                controllerTb.anneeSelectFiltre.value=year;
                              });
                              final storage=FlutterSecureStorage();
                              final String? espace=await storage.read(key:"espace");
                              try{
                                controllerTb.getAllViewTableauBord(annee: controllerTb.anneeSelectFiltre.value, espace: espace);
                              }on Exception catch(e){
                                ScaffoldMessenger.of(context).showSnackBar(showSnackBar("Erreur"
                                    ,"Un Problème est survenue lors du chargement des données", Colors.green));
                              }
                              },
                            child:Text("${year}")),
                        PopupMenuItem(
                            onTap: () async {
                              setState(() {
                                controllerTb.anneeSelectFiltre.value=year+1;
                              });
                              final storage=FlutterSecureStorage();
                              final String? espace=await storage.read(key:"espace");
                              try{
                                controllerTb.getAllViewTableauBord(annee: controllerTb.anneeSelectFiltre.value, espace:espace);
                              }on Exception catch(e){
                                ScaffoldMessenger.of(context).showSnackBar(showSnackBar("Erreur"
                                    ,"Un Problème est survenue lors du chargement des données", Colors.green));
                              }
                              },
                            child:Text("${year+1}")),
                        PopupMenuItem(
                            onTap: ()async{
                              setState(() {
                                controllerTb.anneeSelectFiltre.value=year+2;
                              });
                              final storage=FlutterSecureStorage();
                              final String? espace=await storage.read(key:"espace");
                              try{
                                controllerTb.getAllViewTableauBord(annee: controllerTb.anneeSelectFiltre.value, espace: espace);
                              }on Exception catch(e){
                                ScaffoldMessenger.of(context).showSnackBar(showSnackBar("Erreur"
                                    ,"Un Problème est survenue lors du chargement des données", Colors.green));
                              }
                              },
                            child:Text("${year+2}")),
                      ];
                    },
                    child:EasyContainer(
                        mouseCursor: SystemMouseCursors.click,
                        width: 120,
                        height: 50,
                        showBorder:true,
                        color: Colors.white,
                        customBorderRadius:BorderRadius.circular(10),
                        child: Center(child: Obx(()=>Text("${ controllerTb.anneeSelectFiltre.value}",style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),),
                        ))
                    )
                ),
              ],
            ),
            const SizedBox(width: 10,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Mois",style:TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 18
                )),
                SizedBox(height: 3,),
                Container(
                  width: 120,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.fromBorderSide(
                          BorderSide(
                              width: 1,
                              color: Colors.black
                          )
                      )
                  ),
                  child: CustomDropdown.search(
                        hintText: controllerTb.moisSelectFiltre.value,
                        items:  ["Janvier","Fevrier","Mars","Avril","Mai","Juin","Juillet","Aout","Septembre","Octobre","Novembre","Decembre"],
                        controller: mois_controller,
                        onChanged:(value){
                          controllerTb.moisSelectFiltre.value=value;
                        }
                    ),
                ),
              ],
            ),
            const SizedBox(width: 10,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Filtre",style:TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 18
                )),
                SizedBox(height: 3,),
                Row(
                  children: [
                    PopupMenuButton(
                      tooltip:"Filtrer",
                      icon: Icon(Icons.filter_alt),
                      iconSize:25,
                      shape: RoundedRectangleBorder(
                          side:BorderSide(
                            width:1,
                            color:Colors.black
                          )
                      ),
                      itemBuilder: (BuildContext context) {
                        return [
                          PopupMenuItem(
                            onTap: (){
                              _openAxeFilterDialog();
                            },
                              child: Center(child: Text("Axes",style: TextStyle(color:Colors.black,fontSize: 20,fontWeight: FontWeight.bold),)),
                          ),
                          PopupMenuItem(
                            onTap:(){
                              _openEnjeuFilterDialog();
                            },
                            child: Center(child: Text("Enjeux",style: TextStyle(color:Colors.black,fontSize: 20,fontWeight: FontWeight.bold),)),
                          ),
                          PopupMenuItem(
                            onTap: (){
                              _openCritereFilterDialog();
                            },
                            child: Center(child: Text("Critères",style: TextStyle(color:Colors.black,fontSize: 20,fontWeight: FontWeight.bold),)),
                          ),
                          PopupMenuItem(
                            onTap: (){
                              _openProcessusFilterDialog();
                            },
                            child: Center(child: Text("Processus",style: TextStyle(color:Colors.black,fontSize: 20,fontWeight: FontWeight.bold),)),
                          ),
                        ];
                      },
                    ),
                    // IconButton(
                    //     tooltip:"Filtrer",
                    //     onPressed:(){
                    //       _openTabbedDialog(context);
                    //     },
                    //     icon: Icon(Icons.filter_alt,size: 25,)),
                    SizedBox(width:3,),
                    IconButton(
                          tooltip:"Cliquer pour désactiver les filtres",
                          onPressed:()async{
                            controllerTb.disableFilter();
                            mois_controller.text=controllerTb.moisSelectFiltre.value;
                          },
                          icon: Icon(Icons.filter_alt_off_rounded,size: 25,)),
                  ],
                ),
            ],),
            Expanded(child: Container()),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: IconButton(
            //       splashRadius: 20,padding: EdgeInsets.zero,
            //       onPressed: () async{
            //         String? espace=await storage.read(key:"espace");
            //         setState(() {
            //           controllerTb.moisSelectFiltre.value=mois_controller.text;
            //
            //         });
            //       },
            //       icon: const Icon(Iconsax.refresh,color: Color(0xFF4F80B5),)
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: TextButton.icon(
            //       style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blue)),
            //       onPressed: () {
            //        setState(() {
            //
            //        });
            //       },
            //       icon: const Icon(Iconsax.export,color: Colors.white,),
            //       label: const CustomText(
            //         text: "Exporter",
            //         color: light,
            //         size: 15,
            //       )),
            // ),
            InkWell(
              onTap: (){
                setState(() {
                  updateIndic(context);
                  controllerTb.containerUpdateIndicateurRow=[];
                });
              },
              child:Container(
                  width: 120,
                  padding: const EdgeInsets.all(8),
                  margin: EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    border: Border.all(width: 3.0),
                    borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                  ),
                  child: Center(
                    child: const CustomText(
                      text: "Sauvegarder",
                      size: 13,
                      color: Colors.green,
                    ),
                  )),
            )
            // Container(
            //     padding: const EdgeInsets.all(8),
            //     decoration: BoxDecoration(
            //       border: Border.all(width: 3.0),
            //       borderRadius: const BorderRadius.all(Radius.circular(30.0)),
            //     ),
            //     child: const CustomText(
            //       text: "Collecteur",
            //       size: 13,
            //       color: Colors.green,
            //     ))
          ],
        ),
      );
  }
  Future<void> _openCritereFilterDialog() async {
    await FilterListDialog.display<CritereModel>(
        context,
        hideSelectedTextCount: true,
        themeData: FilterListThemeData(
        context,
        choiceChipTheme: ChoiceChipThemeData.light(context),
    ),
    headlineText: 'Sélectionner Critères',
    width: 500,
    height: 500,
      routeSettings:RouteSettings(
        name: "/pilotage/espace/Trechville/tableau-de-bord/indicateurs",
      ),
    listData:DataCrit,
    selectedListData: selectedCritereList,
    choiceChipLabel: (item) => item!.libelle,
    validateSelectedItem: (list, val) => list!.contains(val),
    controlButtons: [ControlButtonType.All, ControlButtonType.Reset],
    onItemSearch: (critere, query) {
    /// When search query change in search bar then this method will be called
    ///
    /// Check if items contains query
    return critere.libelle!.toLowerCase().contains(query.toLowerCase());
    },

      onApplyButtonClick: (list)async{
        String? espace=await storage.read(key:"espace");
        context.go(Location);
        setState(() {
          controllerTb.criteresTableauBord.value=List.from(list!).isEmpty?controllerTb.criteresTableauBord:List.from(list!);
        });
        controllerTb.doFilter(
          annee: controllerTb.anneeSelectFiltre.value ,
          espace: espace,
          mois:controllerTb.moisSelectFiltre.value,
          axe: selectedAxeList??[],
          critere: selectedCritereList??[],
          enjeu: selectedEnjeuList??[],
        );
      },
    );

  }

  Future<void> _openEnjeuFilterDialog() async {
    await FilterListDialog.display<EnjeuModel>(
      context,
      hideSelectedTextCount: true,
      themeData: FilterListThemeData(
        context,
        choiceChipTheme: ChoiceChipThemeData.light(context),
      ),
      headlineText: 'Sélectionner Enjeux',
      width: 450,
      height: 300,
      listData:DataEnj,
      selectedListData: selectedEnjeuList,
      choiceChipLabel: (item) => item!.libelle,
      validateSelectedItem: (list, val) => list!.contains(val),
      controlButtons: [ControlButtonType.All, ControlButtonType.Reset],
      onItemSearch: (enjeu, query) {
        /// When search query change in search bar then this method will be called
        ///
        /// Check if items contains query
        return enjeu.libelle!.toLowerCase().contains(query.toLowerCase());
      },

      onApplyButtonClick: (list)async{
        String? espace=await storage.read(key:"espace");
        context.go(Location);
        setState(() {
          controllerTb.enjeuxTableauBord.value=List.from(list!).isEmpty?controllerTb.enjeuxTableauBord:List.from(list!);
        });
        controllerTb.doFilter(
          annee: controllerTb.anneeSelectFiltre.value ,
          espace: espace,
          mois:controllerTb.moisSelectFiltre.value,
          axe: selectedAxeList??[],
          critere: selectedCritereList??[],
          enjeu: selectedEnjeuList??[],
        );
      },

    );

  }


  Future<void> _openProcessusFilterDialog() async {
    await FilterListDialog.display<ProcessM>(
      context,
      hideSelectedTextCount: true,
      themeData: FilterListThemeData(
        context,
        choiceChipTheme: ChoiceChipThemeData.light(context),
      ),
      headlineText: 'Sélectionner Processus',
      width: 300,
      height: 400,
      listData:ProcessEntity,
      selectedListData:selectedProcessList,
      choiceChipLabel: (item) => item!.lib,
      validateSelectedItem: (list, val) => list!.contains(val),
      controlButtons: [ControlButtonType.All, ControlButtonType.Reset],
      onItemSearch: (pc, query) {
        /// When search query change in search bar then this method will be called
        ///
        /// Check if items contains query
        return pc.lib!.toLowerCase().contains(query.toLowerCase());
      },

      onApplyButtonClick: (list) {
        setState(() {
          selectedProcessList = List.from(list!);
        });
      },

    );

  }

  Future<void> _openAxeFilterDialog() async {
    await FilterListDialog.display<AxeModel>(
      context,
      hideSelectedTextCount: true,
      themeData: FilterListThemeData(
        context,
        choiceChipTheme: ChoiceChipThemeData.light(context),
      ),
      headlineText: 'Sélectionner Axes',
      width: 250,
      height: 300,
      listData:DataAx,
      selectedListData:selectedAxeList,
      choiceChipLabel: (item) => item!.libelle,
      validateSelectedItem: (list, val) => list!.contains(val),
      controlButtons: [ControlButtonType.All, ControlButtonType.Reset],
      onItemSearch: (axe, query) {
        /// When search query change in search bar then this method will be called
        ///
        /// Check if items contains query
        return axe.libelle!.toLowerCase().contains(query.toLowerCase());
      },

      onApplyButtonClick: (list)async{
        String? espace=await storage.read(key:"espace");
        context.go(Location);
        setState(() {
          controllerTb.axesTableauBord.value=List.from(list!).isEmpty?controllerTb.axesTableauBord:List.from(list!);
        });
        controllerTb.doFilter(
            annee: controllerTb.anneeSelectFiltre.value ,
            espace: espace,
            mois:controllerTb.moisSelectFiltre.value,
          axe: selectedAxeList??[],
          critere: selectedCritereList??[],
          enjeu: selectedEnjeuList??[],
        );
      },
    );

  }

  }

