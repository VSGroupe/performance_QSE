import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../api/api_indicateur.dart';
import '../../controllers/tableau_controller.dart';
import 'controller_tableau_bord/controller_tableau_bord.dart';

class NewTableauBord extends StatefulWidget {
  const NewTableauBord({super.key});

  @override
  State<NewTableauBord> createState() => _NewTableauBordState();
}

class _NewTableauBordState extends State<NewTableauBord> {

  final ControllerTableauBord _controllerTb=Get.find();
  final ApiTableau_Bord api_TB = ApiTableau_Bord();

  // void getIndicateur()async{
  //   await api_TB.getIndicateur(reference:tb_qse.center_cicle.value, annee:DateTime.now().year);
  // }
  double elevation = 10;
final Location="/pilotage/espace/Bouafle/tableau-de-bord/transite-tableau-bord/indicateurs";
 Map<String,Color> listColor={
  "Q":Color.fromRGBO(172,28,12, 1),
   "S":Color.fromRGBO(172,28,12, 1),
   "E":Color.fromRGBO(42,77,4, 1),
   "QE":Color.fromRGBO(172,28,12, 1),
   "SE":Color.fromRGBO(0,38,148, 1),
   "QS":Color.fromRGBO(94,12,13, 1),
   "QSE":Colors.green,
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 80,
          child:Row(
            children: [
              RotatedBox(
                quarterTurns: 2,
                child: IconButton(onPressed:(){
                  _controllerTb.centerCicle.value ="";
                  context.go("/pilotage/espace/Bouafle/tableau-de-bord");
                },
                    icon: Icon(Icons.east_outlined,size: 30,)),
              ),
              SizedBox(width:40),
              Text("Tableau de Bord",style:TextStyle(
                fontSize: 30,fontWeight:FontWeight.bold,
                color:Colors.black,
              )),
            ],
          )
        ),
        SizedBox(height:2),
        Container(
          color: Colors.transparent,
          width: double.infinity,
          height: 600,
          child: Obx(()
            {  String centerCicle=_controllerTb.centerCicle.value;
              double size=280;
              return Stack(
              alignment: Alignment.bottomRight,
              children: [
                StrategyButton(
                  height: size==280?260:100,
                  postionLeft: 0,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  margin: const EdgeInsets.only(right: 25,bottom: 25),//EdgeInsets.only(right: 25,top: 25),
                  postionBotton: 350,
                  colors: [Colors.green, Color(0xFF76A278), Color(0xFFA3C1A5),Color(0xFFE0EAE1)],
                  widgets: [
                    Container(width:300,child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Icon(Icons.manage_accounts)
                        ),
                        SizedBox(width: 5,),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              // _controllerTb.axeSelect.value="axe1";
                              // _controllerTb.nameAxeSelect.value="ALIGNEMENT STRATEGIQUE";
                              context.go(Location);
                            });
                          },
                          child: Text("ALIGNEMENT STRATEGIQUE",maxLines: 3,style: TextStyle(
                              color: Colors.white,fontSize: 18,fontStyle: FontStyle.italic
                          ),),
                        )
                      ],
                    )),

                        Column(
                          children: [
                            SizedBox(height: 10,),
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 20,
                                    width: 20,
                                    child: Container(
                                      height: 20,
                                      width: 20,
                                      decoration: BoxDecoration(
                                          color: Colors.black,
                                          shape: BoxShape.circle
                                      ),
                                      child: Center(child: Text("1",style: TextStyle(color: Colors.white),)),
                                    ),
                                  ),
                                  TextButton(onPressed: () {
                                    setState(() {
                                      // _controllerTbQSE.axeSelect.value="axe1";
                                      // _controllerTbQSE.nameAxeSelect.value="ALIGNEMENT STRATEGIQUE";
                                      // _controllerTbQSE.enjeuSelect.value="enjeu1";
                                      context.go(Location);
                                    });
                                  },
                                      child: Text("Contexte du SMQSE",style: TextStyle(
                                        color: Colors.black,
                                      ),))
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 20,
                                    width: 20,
                                    child: Container(
                                      height: 20,
                                      width: 20,
                                      decoration: BoxDecoration(
                                          color: Colors.black,
                                          shape: BoxShape.circle
                                      ),
                                      child: Center(child: Text("2",style: TextStyle(color: Colors.white),)),
                                    ),
                                  ),
                                  TextButton(onPressed: () {
                                    setState(() {
                                      // _controllerTbQSE.axeSelect.value="axe1";
                                      // _controllerTbQSE.nameAxeSelect.value="ALIGNEMENT STRATEGIQUE";
                                      // _controllerTbQSE.enjeuSelect.value="enjeu2";
                                      context.go(Location);
                                    });
                                  },
                                      child: Text("Leadership et engagement de la direction",style: TextStyle(
                                        color: Colors.black,
                                      ),))
                                ],
                              ),
                            ),
                            SizedBox(height: 10,),
                          ],
                        )
                  ],),
                StrategyButton(
                  height: size==280?260:100,
                  postionLeft:  size+170,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  margin:  EdgeInsets.only(left: 20,bottom: 25),//EdgeInsets.only(right: 25,top: 25),
                  postionBotton: 350,
                  colors: [Colors.blue, Color(0xFF6BB9F7), Color(0xFF9CD0F9),Color(0xFFBDDFFB)],
                  widgets: [
                    Container(
                       width:size==280?300:600,child:
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Icon(Icons.money)
                        ),
                        SizedBox(width: 5,),
                        TextButton(
                          onPressed:() {
                            setState(() {
                              // _controllerTbQSE.axeSelect.value="axe3";
                              // _controllerTbQSE.nameAxeSelect.value="RESILIENCE DU SYSTEME";
                              context.go(Location);
                            });
                          },
                          child: Text("RESILIENCE DU SYSTEME",maxLines: 2,style: TextStyle(
                              color: Colors.white,fontSize: 18,fontStyle: FontStyle.italic
                          ),),
                        )
                      ],
                    )
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 25),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 40,
                                width: 25,
                                child: Container(
                                  height: 25,
                                  width: 25,
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      shape: BoxShape.circle
                                  ),
                                  child: Center(child: Text("9",style: TextStyle(color: Colors.white),)),
                                ),
                              ),
                              SizedBox(width: 5,),
                              TextButton(onPressed: () {
                                setState(() {
                                  // _controllerTbQSE.axeSelect.value="axe3";
                                  // _controllerTbQSE.nameAxeSelect.value="RESILIENCE DU SYSTEME";
                                  // _controllerTbQSE.enjeuSelect.value="enjeu9";
                                  context.go(Location);
                                });
                              },
                                  child: Text("Efficacite et Conformite du SMQSE",style: TextStyle(
                                      color: Colors.black
                                  ),))
                            ],
                          ),
                        ),
                      ],
                    )
                  ],),
                StrategyButton(
                  height:size==280?285:100,
                  postionLeft: size+170,
                  postionBotton: size==280?100:230,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  margin: EdgeInsets.only(left: 25,top: 25),
                  colors: [Colors.amber,Color(0xFFFFEB3B), Color(0xFFFFF17C), Color(0xFFFFFAD3)],
                  widgets: [
                    Padding(
                      padding: const EdgeInsets.only(left: 110),
                      child:Container(
                          width:size==280?250:600,child:
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 40),
                            child: Icon(Iconsax.people),
                          ),
                          SizedBox(width: 5,),
                          Container(
                            width:200,height: 100,
                            child: TextButton(
                              onPressed: () {
                                // _controllerTbQSE.axeSelect.value="axe4";
                                // _controllerTbQSE.nameAxeSelect.value="PERFORMANCE & INTEGRITE DU SYSTEME";
                                context.go(Location);
                              },
                              child: Text("PERFORMANCE & INTEGRITE DU SYSTEME",maxLines:3,style: TextStyle(
                                  color: Colors.white,fontSize: 18,fontStyle: FontStyle.italic
                              ),),
                            ),
                          )
                        ],
                      )
                      ),
                    ),
                    size==280?
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 40),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 25),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 40,
                                      width: 20,
                                      child: Container(
                                        height: 20,
                                        width: 20,
                                        decoration: BoxDecoration(
                                            color: Colors.black,
                                            shape: BoxShape.circle
                                        ),
                                        child: Center(child: Text("10",style: TextStyle(color: Colors.white),)),
                                      ),
                                    ),
                                    SizedBox(width: 5,),
                                    TextButton(onPressed: () {  },
                                        child: Text("Égalité de traitement",style: TextStyle(
                                          color: Colors.black,
                                        ),))
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ):Column()
                  ],
                ),
                StrategyButton(
                  height:size==280?285:100,
                  postionLeft:0,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  margin: EdgeInsets.only(right: 25,top: 25),//EdgeInsets.only(right: 25,top: 25),
                  postionBotton: size==280?100:230,
                  colors: [Color(0xFFF36C2B), Color(0xFFF89D61), Color(0xFFFABA8D), Color(0xFFFDD6B9)],
                  widgets: [
                    Container(width:250,child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child:Icon(Iconsax.tree),
                        ),
                        SizedBox(width: 2,),
                        Container(
                          width:200,height: 50,
                          child: TextButton(
                            onPressed:size==280? () {
                              setState(() {
                                // _controllerTbQSE.axeSelect.value="axe2";
                                // _controllerTbQSE.nameAxeSelect.value="MAITRISE OPERATIONNELLE";
                                context.go(Location);
                              });
                            }:null,
                            child: Text("MAITRISE OPERATIONNELLE",style: TextStyle(
                                color: Colors.white,fontSize: 18,fontStyle: FontStyle.italic
                            ),),
                          ),
                        )
                      ],
                    )),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 20,
                                width: 20,
                                child: Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      shape: BoxShape.circle
                                  ),
                                  child: Center(child: Text("3",style: TextStyle(color: Colors.white),)),
                                ),
                              ),
                              TextButton(onPressed: () {
                                setState(() {
                                  // _controllerTbQSE.axeSelect.value="axe2";
                                  // _controllerTbQSE.nameAxeSelect.value="MAITRISE OPERATIONNELLE";
                                  // _controllerTbQSE.enjeuSelect.value="enjeu3";
                                  context.go(Location);
                                });
                              },
                                  child: Text("Management du QSE",style: TextStyle(
                                    color: Colors.black,
                                  ),))
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 20,
                                width: 20,
                                child: Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      shape: BoxShape.circle
                                  ),
                                  child: Center(child: Text("4",style: TextStyle(color: Colors.white),)),
                                ),
                              ),
                              Container(
                                  width:300,height: 30,
                                  child:
                                  TextButton(onPressed: () {
                                    setState(() {
                                      // _controllerTbQSE.axeSelect.value="axe2";
                                      // _controllerTbQSE.nameAxeSelect.value="MAITRISE OPERATIONNELLE";
                                      // _controllerTbQSE.enjeuSelect.value="enjeu4";
                                      context.go(Location);
                                    });
                                  },
                                      child: Text("Maitrise des impacts et effets indesirables",style: TextStyle(
                                        color: Colors.black,
                                      ),)))
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 20,
                                width: 20,
                                child: Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      shape: BoxShape.circle
                                  ),
                                  child: Center(child: Text("5",style: TextStyle(color: Colors.white),)),
                                ),
                              ),
                              TextButton(onPressed: () {
                                setState(() {
                                  // _controllerTbQSE.axeSelect.value="axe2";
                                  // _controllerTbQSE.nameAxeSelect.value="MAITRISE OPERATIONNELLE";
                                  // _controllerTbQSE.enjeuSelect.value="enjeu5";
                                  context.go(Location);
                                });
                              },
                                  child: Text("Ressource",style: TextStyle(
                                    color: Colors.black,
                                  ),))
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 20,
                                width: 20,
                                child: Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      shape: BoxShape.circle
                                  ),
                                  child: Center(child: Text("6",style: TextStyle(color: Colors.white),)),
                                ),
                              ),
                              TextButton(onPressed: () {
                                setState(() {
                                  // _controllerTbQSE.axeSelect.value="axe2";
                                  // _controllerTbQSE.nameAxeSelect.value="MAITRISE OPERATIONNELLE";
                                  // _controllerTbQSE.enjeuSelect.value="enjeu6";
                                  context.go(Location);
                                });
                              },
                                  child: Text("Planification",style: TextStyle(
                                    color: Colors.black,
                                  ),))
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 20,
                                width: 20,
                                child: Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      shape: BoxShape.circle
                                  ),
                                  child: Center(child: Text("7",style: TextStyle(color: Colors.white),)),
                                ),
                              ),
                              TextButton(onPressed: () {
                                setState(() {
                                  // _controllerTbQSE.axeSelect.value="axe2";
                                  // _controllerTbQSE.nameAxeSelect.value="MAITRISE OPERATIONNELLE";
                                  // _controllerTbQSE.enjeuSelect.value="enjeu7";
                                  context.go(Location);
                                });
                              },
                                  child: Text("Conception et modification",style: TextStyle(
                                    color: Colors.black,
                                  ),))
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 20,
                                width: 20,
                                child: Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      shape: BoxShape.circle
                                  ),
                                  child: Center(child: Text("8",style: TextStyle(color: Colors.white),)),
                                ),
                              ),
                              Container(
                                  width:360,height: 30,
                                  child:TextButton(onPressed: () {
                                    setState(() {
                                      // _controllerTbQSE.axeSelect.value="axe2";
                                      // _controllerTbQSE.nameAxeSelect.value="MAITRISE OPERATIONNELLE";
                                      // _controllerTbQSE.enjeuSelect.value="enjeu8";
                                      context.go(Location);
                                    });
                                  },
                                      child: Text("Realisation,liberation des produits et externalisation",style: TextStyle(
                                        color: Colors.black,
                                      ),)))
                            ],
                          ),
                        ),
                      ],
                    )
                  ],),
                Positioned(
                    left: 320,
                    bottom: size==400?150:210,
                    child: AnimatedContainer(
                      duration: Duration(seconds: 1),
                      curve: Curves.fastOutSlowIn,
                      height: size,
                      width: size,
                      decoration: const BoxDecoration(
                          color: Color(0xFFFDFDFD),
                          shape: BoxShape.circle
                      ),

                      child: Center(

                        child: AnimatedContainer(
                          duration: Duration(seconds: 1),
                          curve: Curves.fastOutSlowIn,
                            height: size-30,
                            width: size-30,
                            decoration: const BoxDecoration(
                            color: Color.fromRGBO(241,245,246, 1),
                            shape: BoxShape.circle
                            ),
                            child:Center(child: Text("${centerCicle}",style: TextStyle(fontSize: 60,color:listColor[centerCicle],fontWeight: FontWeight.bold),)),
                            )
                      ),
                    )
                ),
              ],
            );}
          ),
        ),
      ],
    );
  }
}

class StrategyButton extends StatefulWidget {
  final double postionLeft;
  final double postionBotton;
  final List<Widget> widgets;
  final List<Color> colors;
  final EdgeInsetsGeometry margin;
  final double? height;
  final CrossAxisAlignment crossAxisAlignment;
  final Function()? onTap;
  const StrategyButton({super.key, required this.postionLeft,
    required this.postionBotton, required this.widgets,required this.colors, required this.margin, required this.crossAxisAlignment, this.onTap,  this.height});

  @override
  State<StrategyButton> createState() => _StrategyButtonState();
}

class _StrategyButtonState extends State<StrategyButton> {
  double elevation = 20;
  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: widget.postionLeft,
        bottom: widget.postionBotton,
        child: Container(
          padding: widget.margin,
          width: 470,height: widget.height?? 260,
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: widget.colors,
                  stops: [0.3,0.5,0.7,0.9],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: widget.crossAxisAlignment,
              children: widget.widgets,
            ),
          ),
        )
    );
  }
}