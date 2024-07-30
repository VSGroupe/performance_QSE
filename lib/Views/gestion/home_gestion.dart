import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:go_router/go_router.dart';
import 'package:perfqse/Views/audit/controller/controller_audit.dart';

class DrawerGestion extends StatefulWidget {
  const DrawerGestion({Key? key}) : super(key: key);

  @override
  State<DrawerGestion> createState() => _DrawerGestionState();
}

class _DrawerGestionState extends State<DrawerGestion> {
  final ControllerAudit controllerAudit =Get.put(ControllerAudit());
  @override
  void initState() {
    controllerAudit.reference.value="";
    super.initState();
  }

  Future<void> _showDialogNoAcces() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text(
            "Aucune performance\nsélectionnée",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.red),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Veuillez sélectionner la performance à auditer\ndans l'espace à droite."),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 20, right: 0, bottom: 20),
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: Container(
          width: 250,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
              color: Colors.white,
              border: Border.fromBorderSide(
                BorderSide(width: 2, color: Colors.grey),
              )),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 250,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 11.3),
                      child: Container(
                        width: 200,
                        decoration: const BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        child: TextButton(
                            onPressed: () {
                              setState(() {
                                if (controllerAudit.reference.value == "") {
                                  _showDialogNoAcces();
                                } else {
                                  context.go("/audit/gestion-audits");
                                }
                              });
                            },

                            child: const Text(
                              "GESTION",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            )),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text(
                      "Menu Principal",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ],
                ),
              ),
              Container(
                width: 240,
                padding: const EdgeInsets.all(8),
                child: const Divider(
                  color: Colors.black,
                ),
              ),
              Obx(() => CustomMenuButton(
                pathMenu: controllerAudit.reference.value == "" ? "":"/gestion/transite",
                image: "assets/images/home1.png",
                isFullPath: false,
                label: "Accueil",
                onTap: () {
                  // Set the reference value to an empty string
                  controllerAudit.reference.value = "";
                },
              )),
              const SizedBox(height: 5),
              Obx(()
              =>  CustomMenuButton(
                pathMenu: controllerAudit.reference.value==""? "":"/gestion/accueil",
                image: "assets/images/audit.jpg",
                isFullPath: false,
                // icon: Icons.home,
                label: "Aperçu des audits",
                onTap: () {
                  // Action to execute
                  if(controllerAudit.reference.value == ""){
                    _showDialogNoAcces();
                  }
                },
              ),
              ),
              const SizedBox(height: 5),
              Obx(()
              => CustomMenuButton(
                pathMenu:controllerAudit.reference.value==""?"":'/audit/profil',
                image: "assets/images/profile-user.png",
                // icon: Icons.person,
                isFullPath: false,
                label: "Profil",
                onTap: () {
                  // Action to execute
                  if(controllerAudit.reference.value == ""){
                    _showDialogNoAcces();
                  }
                },
              ),
              ),
              const SizedBox(height: 5),
              Obx(()
              => CustomMenuButton(
                pathMenu: controllerAudit.reference.value==""?"":'/audit/gestion-audits',
                image: "assets/images/audit.png",
                // icon: Icons.table_chart_rounded,
                isFullPath: false,
                label: "Gestion Audits",
                onTap: () {
                  // Action to execute
                  if(controllerAudit.reference.value == ""){
                    _showDialogNoAcces();
                  }
                },
              ),
              ),
              const SizedBox(height: 5),
              Obx(()
              => CustomMenuButton(
                pathMenu: controllerAudit.reference.value==""?"":'/audit/admin',
                image: "assets/images/homme-daffaire.png",
                // icon: Icons.admin_panel_settings_outlined,
                isFullPath: false,
                label: "Administration",
                onTap: () {
                  // Action to execute
                  if(controllerAudit.reference.value == ""){
                    _showDialogNoAcces();
                  }
                },
              ),
              ),
              const SizedBox(height: 5),
              const CustomMenuButton(
                pathMenu: '',
                image: "assets/images/res.png",
                // icon: Icons.admin_panel_settings_outlined,
                isFullPath: false,
                label: "Réssources",
              ),
              const SizedBox(height: 5,),
              Container(
                width: 240,
                padding: const EdgeInsets.all(8),
                child: const Divider(
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              const CustomMenuButton(
                pathMenu: '/',
                image: "assets/images/return.png",
                isFullPath: true,
                // icon: Icons.arrow_circle_left_sharp,
                label: "Accueil Général",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomMenuButton extends StatefulWidget {
  final String pathMenu;
  final String image;
  final bool isFullPath;
  final String label;
  final VoidCallback? onTap; // Pour pouvoir effectuer une action lorqu'on clique sur le bouton

  const CustomMenuButton({
    Key? key,
    required this.label,
    required this.pathMenu,
    required this.isFullPath,
    required this.image,
    this.onTap, // On pourra ainsi définir une action à exécuter lorsqu'on clique sur le bouton
  }) : super(key: key);

  @override
  State<CustomMenuButton> createState() => _CustomMenuButtonState();
}


class _CustomMenuButtonState extends State<CustomMenuButton> {
  bool _isHovering = false;
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      onTap: () {
        if (widget.onTap != null) {
          widget.onTap!(); // Call the onTap callback
        }
        context.go(widget.pathMenu);
      },
      onHover: (isHovering) {
        setState(() {
          _isHovering = isHovering;
        });
      },
      child: Container(
        width: 248,
        height: 40,
        decoration: BoxDecoration(
            color: isSelected
                ? _isHovering
                ? const Color(0xFFEEEEEE)
                : const Color(0xFFE8F0FE)
                : Colors.transparent,
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20))),
        child: OutlinedButton(
          onPressed: () {
            if (widget.onTap != null) {
              widget.onTap!(); // Call the onTap callback
            }
            context.go(widget.pathMenu);
          },
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.transparent,
            side: const BorderSide(
              color: Colors.transparent,
            ),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20))),
          ),
          child: Row(
            children: [
              Image.asset(
                widget.image,
                width: 30,
              ),
              const SizedBox(
                width: 18,
              ),
              Text(
                widget.label,
                style: TextStyle(
                    fontSize: 18,
                    overflow: TextOverflow.ellipsis,
                    color: isSelected ? const Color(0xFF114693) : Colors.black),
              )
            ],
          ),
        ),
      ),
    );
  }
}

