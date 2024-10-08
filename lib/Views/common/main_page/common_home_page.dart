import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:marquee_text/marquee_direction.dart';
import 'package:marquee_text/marquee_text.dart';
import 'package:perfqse/Views/common/main_page/widget/banniere.dart';
import 'package:perfqse/Views/common/main_page/widget/custom_cadre.dart';
import 'package:perfqse/Views/common/main_page/widget/header_main_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../widgets/copyright.dart';
import '../../../helpers/helper_methods.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final storage = FlutterSecureStorage();
  final supabase = Supabase.instance.client;
  late Future<Map> mainData;

  @override
  void initState() {
    super.initState();
    mainData = loadDataMain();
  }

  Future<Map> loadDataMain() async {
    var data = {};
    String? email = await storage.read(key: 'email');
    final user = await supabase.from('Users').select().eq('email', email);
    data["user"] = user[0];
    return data;
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Accès refusé'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Vous n'avez pas accès à cet espace."),
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

  Future<bool> checkAccesGestion() async {
    final accesOk = true;
    if (accesOk){
      context.go("/gestion/accueil");
    }
    //_showMyDialog();
    return !accesOk;
  }

  Future<bool> checkAccesPilotage(String email) async {
    final result =
        await supabase.from("AccesPilotage").select().eq("email", email);
    final acces = result[0];
    if (acces["est_bloque"]) {
      _showMyDialog();
      return false;
    }
    if (acces["est_spectateur"] ||
        acces["est_collecteur"] ||
        acces["est_validateur"] ||
        acces["est_admin"]) {
      context.go("/accueil_pilotage");
      return true;
    }
    _showMyDialog();
    return false;
  }

  Future<bool> checkAccesEvaluation(String email) async {
    var data;
    final result = await supabase.from("AccesAudit").select().eq("email", email);
    final acces = result[0];
    if (acces["est_bloque"]) {
      _showMyDialog();
      return false;
    }
    if (acces["est_spectateur"] ||
        acces["est_collecteur"] ||
        acces["est_validateur"] ||
        acces["est_admin"]) {
      context.go("/audit/transite");
      return true;
    }
    _showMyDialog();
    return false;
  }

  Future<bool> checkAccesRapport() async {
    final accesOk = true;
    //if (accesOk){
      //context.go("/rapport/accueil");
    //}
    _showMyDialog();
    return !accesOk;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map>(
      future: mainData,
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
      body: Column(
        children: [
              HeaderMainPage(title: "Général",mainPageData: data,),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                height: 670,
                padding: const EdgeInsets.all(5.0),
                width: double.infinity,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                            "assets/images/background_image.jpg"),
                        fit: BoxFit.fitWidth)
                ),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: SizedBox(
                                width: 450,
                                height: 30,
                                child: MarqueeText(
                                  text: const TextSpan(
                                      text: "Bienvenue dans ",
                                      style: TextStyle(
                                          fontSize: 27,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: "Performance ",
                                            style: TextStyle(
                                                color: Color(0xFF2A9836))),
                                        TextSpan(
                                            text: "QSE",
                                            style: TextStyle(
                                                color: Colors.red)),
                                      ]),
                                  textDirection: TextDirection.ltr,
                                  marqueeDirection: MarqueeDirection.rtl,
                                  alwaysScroll: true,
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.black,
                                  ),
                                  speed: 18,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            RichText(
                              text: const TextSpan(
                                  text: " Piloter ",
                                  style: TextStyle(
                                      fontSize: 23,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text:
                                        "éfficacement votre ",
                                        style:
                                        TextStyle(color: Colors.black,fontSize: 23,)),
                                    TextSpan(
                                        text: "Performance ",
                                        style: TextStyle(
                                            color: Color(0xFF2A9836),fontSize: 23,)),
                                    TextSpan(
                                        text: "globale ",
                                        style: TextStyle(
                                            color: Color(0xFF2A9836),fontSize: 23,)),
                                    TextSpan(
                                        text: "QSE ",
                                        style:
                                            TextStyle(color: Colors.red,fontSize: 23),),
                                    TextSpan(
                                        text: "avec simplicité ",
                                        style: TextStyle(
                                            color: Color(0xFF2A9836),fontSize: 23,)),
                                  ]),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height:10,
                        ),
                        const Banniere(),
                        Expanded(
                          flex:4,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CustomCadre(
                                onTap: () {
                                  checkAccesGestion();
                                },
                                imagePath: "assets/images/aller_vers_gestion.png",
                                titreCadre: "Gestion",
                              ),
                              CustomCadre(
                                onTap: () {
                                  checkAccesPilotage(
                                      "${data["user"]["email"]}");
                                },
                                imagePath: "assets/images/pilotageUpdate.png",
                                titreCadre: "Pilotage",
                              ),
                              CustomCadre(
                                onTap: () async {
                                  checkAccesEvaluation(
                                      "${data["user"]["email"]}");
                                },
                                imagePath: "assets/images/auditUpdate.png",
                                titreCadre: "Audit",
                              ),
                              // CustomCadre(
                              //   onTap: () {
                              //     checkAccesRapport();
                              //   },
                              //   imagePath: "assets/images/rapportUpdate.png",
                              //   titreCadre: "Rapport",
                              // ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Positioned(
                      bottom: 60,
                      child: RotatedBox(
                        quarterTurns: 2,
                        child: IconButton(
                            onPressed: () async {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text(
                                        "Voulez-vous quitter l'application ?"),
                                    content: const SizedBox(
                                        width: 200,
                                        child: Text(
                                            'Cliquez sur Oui pour vous déconnecter.')),
                                    actionsAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    actions: <Widget>[
                                      OutlinedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('Non'),
                                      ),
                                      OutlinedButton(
                                        onPressed: () async {
                                          await storage.write(
                                              key: 'logged', value: "");
                                          await storage.write(
                                              key: 'userEmail', value: "");
                                          context.go('/account/login');
                                        },
                                        child: Text('Oui'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            tooltip: "Se Deconnecter",
                            icon: Icon(
                              Icons.output_rounded,
                              color: Colors.red,
                              size: 40,
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const CopyRight()
        ],
      ),
    );
  },
  );
  }
}
