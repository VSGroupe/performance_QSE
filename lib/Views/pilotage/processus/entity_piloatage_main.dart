import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:perfqse/Views/pilotage/controllers/data.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../helpers/helper_methods.dart';
import '../../../../utils/utils.dart';
import '../../../common.dart';
import '../controllers/side_menu_controller.dart';
import 'tableau_bord/controller_tableau_bord/controller_tableau_bord.dart';
import 'widgets/app_bar_pilotage.dart';
import 'widgets/drawer_menu_pilotage.dart';
import 'widgets/menu_nav_pilotage.dart';


class EntityPilotageMain extends StatefulWidget {
  final Widget child;
  const EntityPilotageMain({super.key, required this.child});

  @override
  State<EntityPilotageMain> createState() => _EntityPilotageMainState();
}

class _EntityPilotageMainState extends State<EntityPilotageMain> {

  final SideMenuController sideMenuController = Get.put(SideMenuController());
  final ControllerTableauBord controllerTableauBord=Get.put(ControllerTableauBord());
  final storage = FlutterSecureStorage();
  final supabase = Supabase.instance.client;
  String shortName ="";
  String? ref;
  late Future<Map> pilotageEntiteData;
  bool isLoading = true;

  Future<Map> chekUserAccesPilotage() async{
    var data = {};
    String? email = await storage.read(key: 'email');
    final user = await supabase.from('Users').select().eq('email', email);
    data["user"] = user[0] ;
    ref=data["user"]["reference"].join("\n");
    await storage.write(key: "ref",value:ref);
    return data;
  }


  @override
  void initState() {
   pilotageEntiteData=chekUserAccesPilotage();
    super.initState();
   _loadSiteAndProcessus(); // Fonction pour récupérer Site et Processus
  }

  Future<void> _loadSiteAndProcessus() async {
    try {
      String currentSite = await getCurrentSite();
      String currentProcessus = await getProcessusClique();

      setState(() {
        Site = currentSite;
        Processus = currentProcessus;
        isLoading = false; // Charger terminé
      });
    } catch (e) {
      print("Erreur lors de la récupération du site et du processus: $e");
      // Gérer l'erreur ici, comme une redirection vers une page d'erreur
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map>(
      future:pilotageEntiteData,
      builder: (context,snapshot){
        if(!snapshot.hasData){
          return Scaffold(
            body: Container(
              child:Center(child: loadingPageWidget())
            ),
          );
        }
        final data=snapshot.data;
        int width = MediaQuery.of(context).size.width.round();
        String responsive = responsiveRule(width);
        shortName="${data?["user"]["prenom"][0]}${data?["user"]["nom"][0]}";
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60.0),
            child: AppBarPilotage(shortName:shortName,),
          ),
          body: Scaffold(
            key: sideMenuController.scaffoldKey,
            drawer: const DrawerMenuPilotage(),
            endDrawer: const DrawerMenuPilotage(),
            body: Row(
              children: [MenuNavPilotage(responsive: responsive),Expanded(child: widget.child)],
            ),
          ),
        );
      }
    );
  }
}
