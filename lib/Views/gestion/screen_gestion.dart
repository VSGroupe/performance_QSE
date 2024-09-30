import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:go_router/go_router.dart';
import 'package:perfqse/Views/gestion/widgets/app_bar_gestion.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../helpers/helper_methods.dart';
import '../audit/autre/widgets/drawer_audit.dart';
import '../audit/autre/widgets/evaluation_utils.dart';
import '../audit/widget/app_bar_audit.dart';
import '../pilotage/processus/tableau_bord/controller_tableau_bord/controller_tableau_bord.dart';
import 'home_gestion.dart';

class ScreenGestion extends StatefulWidget {
  final Widget child;
  /// Constructs a [ScreenGestion] widget.
  const ScreenGestion({super.key, required this.child});

  @override
  State<ScreenGestion> createState() =>
      _ScreenGestionState();
}

class _ScreenGestionState extends State<ScreenGestion> {
  final storage = FlutterSecureStorage();
  final supabase = Supabase.instance.client;
  final ControllerTableauBord controllerTb=Get.put(ControllerTableauBord());
  late Future<Map> EvaluationData;


  Future<Map> loadDataEvaluation() async{
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
  void initState() {
    super.initState();
    EvaluationData = loadDataEvaluation();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return FutureBuilder<Map?>(
        future: EvaluationData,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: loadingPageWidget(),
              ),
            );
          }
          final data = snapshot.data!;

          return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(60.0),
              child: AppBarGestion(),
            ),
            body: Scaffold(
              drawer: const DrawerGestion(),
              endDrawer: const DrawerGestion(),
              body: Row(
                children: [
                  const DrawerGestion(),
                  Expanded(child: widget.child)],
              ),
            ),
          );
        }
    );
  }
}
