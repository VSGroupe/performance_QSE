import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../../../helpers/helper_methods.dart';
import '../tableau_bord/controller_tableau_bord/controller_tableau_bord.dart';
import '../widgets/privacy_widget.dart';
import 'monitoring_pilotage.dart';

class ScreenPilotageSuivi extends StatefulWidget {
  /// Constructs a [ScreenPilotageSuivi] widget.
  const ScreenPilotageSuivi({super.key});

  @override
  State<ScreenPilotageSuivi> createState() => _ScreenPilotageSuiviState();
}

class _ScreenPilotageSuiviState extends State<ScreenPilotageSuivi> {
  bool _isLoaded = false;
  late ScrollController _scrollController;
  final ControllerTableauBord controllerTableauBord=Get.find();
  void loadScreen() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      _isLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    loadScreen();
    controllerTableauBord.assemblyIndicateurWithDataIndicateur();
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    int width = MediaQuery.of(context).size.width.round();
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 16,left: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Suivi des données",style: TextStyle(fontSize: 24,color: Color(0xFF3C3D3F),fontWeight: FontWeight.bold),),
            SizedBox(height: 5,),
            _isLoaded ? const Expanded(child: Padding(
              padding: EdgeInsets.only(right: 5.0),
              child: Column(
                children: [
                  Expanded(child: MonitoringPilotage2(),),
                  SizedBox(height: 20,),
                  PrivacyWidget(),
                  SizedBox(height: 20,),
                ],
              ),
            )) : Expanded(
              child: Column(
                children: [
                  Expanded(child: Center(
                    child: loadingPageWidget(),//const SpinKitRipple(color: Colors.blue,),
                  )),
                  SizedBox(height: 20,),
                  PrivacyWidget(),
                  SizedBox(height: 20,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}