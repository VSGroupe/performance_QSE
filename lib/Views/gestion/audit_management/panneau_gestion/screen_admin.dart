import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../helpers/helper_methods.dart';
import '../../../../models/common/user_model.dart';
import '../../../../models/pilotage/acces_pilotage_model.dart';
import '../../../../utils/pilotage_utils.dart';
import '../../../audit/autre/widgets/evaluation_utils.dart';
import '../../../audit/constant/constants.dart';
import '../../../audit/profil/controller/profil_pilotage_controller.dart';
import '../../../pilotage/entity/tableau_bord/controller_tableau_bord/controller_tableau_bord.dart';
import 'admin.dart';

class ScreenAdmin extends StatefulWidget {
  /// Constructs a [ScreenAdmin] widget.
  const ScreenAdmin({super.key});

  @override
  State<ScreenAdmin> createState() => _ScreenAdminState();
}

class _ScreenAdminState extends State<ScreenAdmin> {

  final storage = FlutterSecureStorage();
  final ProfilPilotageController userController= Get.put(ProfilPilotageController());
  final ControllerTableauBord controllerTableauBord=Get.find();
  final supabase = Supabase.instance.client;
  late Future<Map> pilotageEntiteData;

  Future<Map> chekUserAccesAudit() async{
    var data = {};
    String? email = await storage.read(key: 'email');
    final user = await supabase.from('Users').select().eq('email', email);
    final accesEvaluation = await supabase.from('AccesAudit').select().eq('email', email);
    data["user"] = user[0] ;
    data["AccesAudit"] = accesEvaluation[0] ;
    if(checkAccesPilotage(accesEvaluation[0]) ==false) {
      await Future.delayed(Duration(milliseconds: 500));
      context.go("/");
    }
    return data;
  }


  @override
  void initState(){
    pilotageEntiteData = chekUserAccesAudit();
    controllerTableauBord.assemblyIndicateurWithDataIndicateur();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map?>(
      future: pilotageEntiteData,
      builder: (context,snapshot){
        if (!snapshot.hasData) {
          return Center(
            child: loadingPageWidget(),//const SpinKitRipple(color: Colors.blue,),
          );
        }
        final data = snapshot.data!;
        return Scaffold(
          body: Padding(
            padding: EdgeInsets.only(top: 16,left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Panneau d'administration",style: headerBoldStyle),
                SizedBox(height: 5,),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(child: Container(
                          child: Admin()
                      ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }


}