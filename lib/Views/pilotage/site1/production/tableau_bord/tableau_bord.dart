import 'package:flutter/material.dart';
import 'package:easy_container/easy_container.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:go_router/go_router.dart';
import 'controller_tableau_bord/controller_tableau_bord.dart';

class TableauBord extends StatefulWidget {
  const TableauBord({super.key});

  @override
  State<TableauBord> createState() => _TableauBordState();
}

class _TableauBordState extends State<TableauBord> {
  final storage =FlutterSecureStorage();
  final ControllerTableauBord controllerTb =Get.find();
  final Location="/pilotage/espace/Com/tableau-de-bord/transite-tableau-bord";

  Future<void> _showDialogNoAcces() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Accès refusé'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Vous n'avez pas la référence d'accès à cet espace."),
                SizedBox(
                  height: 20,
                ),
                Image.asset(
                  "assets/images/forbidden.png",
                  width: 50,
                  height: 50,
                )
              ],
            ),
          ),
        );
      },
    );
  }


  void getAccess(String centerTitle)async{
    String? reference = await storage.read(key:"ref");
    List<String> ref=[""];
    if (reference!=null){
      ref =reference.split("\n");
    }
    if(ref.contains(centerTitle)) {
      controllerTb.centerCicle.value = centerTitle;
      context.go(Location);
    }else{
      _showDialogNoAcces();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 630,
      width: 1000,
      child: Stack(children: [
        Positioned(
            top: 160,
            right: 385,
            child: SizedBox(
              height: 250,
              width: 250,
              child: InkWell(
                  onTap: (){
                    setState(() {
                      getAccess("QSE");
                    });
                  },
                  mouseCursor: SystemMouseCursors.click,
                  child: Image.asset("assets/images/qse.png", fit: BoxFit.contain)),
            )),
        Positioned(
            top: 0,
            right: 350,
            child: SizedBox(
              height: 160,
              width: 300,
              child: InkWell(
                  onTap: (){
                    setState(() {
                      getAccess("QS");
                    });
                  },
                  mouseCursor: SystemMouseCursors.click,child: Image.asset("assets/images/qs.png", fit: BoxFit.contain)),
            )),
        Positioned(
            bottom:0,
            right: 350,
            child: SizedBox(
            height: 200,
            width: 300,
            child: InkWell(
                onTap: (){
                  setState(() {
                    getAccess("E");
                  });
                },
                mouseCursor: SystemMouseCursors.click,child: Image.asset("assets/images/e.png", fit: BoxFit.contain)),
            )),
        Positioned(
            top: 140,
            left: 60,
            child: SizedBox(
            height: 160,
            width: 300,
            child: InkWell(
              onTap: (){
                setState(() {
                  getAccess("Q");
                });
              },
                mouseCursor: SystemMouseCursors.click,child: Image.asset("assets/images/q.png", fit: BoxFit.contain)),
            )),
        Positioned(
            top: 140,
            right: 60,
            child: SizedBox(
            height: 160,
            width: 300,
            child: InkWell(
                onTap: (){
                  setState(() {
                    getAccess("S");
                  });
                },
                mouseCursor: SystemMouseCursors.click,child: Image.asset("assets/images/s.png", fit: BoxFit.contain)),
            )),
        Positioned(
            top: 340,
            right: 100,
            child: SizedBox(
            height: 200,
            width: 250,
            child: InkWell(
                onTap: (){
                  setState(() {
                    getAccess("SE");
                  });
                },
                mouseCursor: SystemMouseCursors.click,child: Image.asset("assets/images/se.png", fit: BoxFit.contain)),
            )),
        Positioned(
            top: 340,
            left: 100,
            child: SizedBox(
            height: 200,
            width: 250,
            child: InkWell(
                onTap: (){
                  setState(() {
                    getAccess("QE");
                  });
                },
                mouseCursor: SystemMouseCursors.click,child: Image.asset("assets/images/qe.png", fit: BoxFit.contain)),
            )),
      ]),
    );
  }
}
