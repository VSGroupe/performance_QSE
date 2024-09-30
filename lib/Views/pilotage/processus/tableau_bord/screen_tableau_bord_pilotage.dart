import 'package:flutter/material.dart';
import '../../../../../helpers/helper_methods.dart';
import '../widgets/privacy_widget.dart';
import "tableau_bord.dart";

class ScreenTableauBordPilotage extends StatefulWidget {
  /// Constructs a [ScreenTableauBordPilotage] widget.
  const ScreenTableauBordPilotage({super.key});

  @override
  State<ScreenTableauBordPilotage> createState() => _ScreenTableauBordPilotageState();
}

class _ScreenTableauBordPilotageState extends State<ScreenTableauBordPilotage> {
  bool _isLoaded = false;


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
            _isLoaded ? Expanded(
              child: SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  child: Column(
                    children: [
                     Center(child: TableauBord()),//IndicateurScreen(),//NewTableauBord(),
                      SizedBox(height: 10,),
                      PrivacyWidget(),
                      SizedBox(height: 10,),
                    ],
                  ),
                ),
              ),
            ) : Expanded(
              child: Column(
                children: [
                  Expanded(child: Center(
                    child: loadingPageWidget(),//const SpinKitRipple(color: Colors.blue,),
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}