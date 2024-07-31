import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:perfqse/Views/audit/controller/controller_audit.dart';

class DrawerGestion extends StatefulWidget {
  const DrawerGestion({Key? key}) : super(key: key);

  @override
  State<DrawerGestion> createState() => _DrawerGestionState();
}

class _DrawerGestionState extends State<DrawerGestion> {
  final ControllerAudit controllerAudit = Get.put(ControllerAudit());

  @override
  void initState() {
    controllerAudit.reference.value = "";
    super.initState();
  }

  Future<void> _showDialogNoAccess() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text(
            "Accès refusé",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.red),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Vous n'avez pas les droits d'accès\nà ce contenu"),
                SizedBox(height: 20),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: 250,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            border: Border.all(width: 2, color: Colors.grey),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Header(onDialogRequest: _showDialogNoAccess),
              const _Divider(),
              Obx(() => _buildMenuButton(
                pathMenu: controllerAudit.reference.value.isEmpty ? "/gestion/accueil" : "/gestion/accueil",
                image: "assets/images/home1.png",
                label: "Accueil",
                onTap: () => controllerAudit.reference.value = "",
              )),
              const SizedBox(height: 5),
              Obx(() => _buildMenuButton(
                pathMenu: controllerAudit.reference.value.isEmpty ? '/gestion/profil' : '/gestion/profil',
                image: "assets/images/profile-user.png",
                label: "Profil",
              )),
              const SizedBox(height: 5),
              Obx(() => _buildMenuButton(
                pathMenu: controllerAudit.reference.value.isEmpty ? "/gestion/admin" : '/gestion/admin',
                image: "assets/images/homme-daffaire.png",
                label: "Admin audits",
              )),
              const SizedBox(height: 5),
              Obx(() => _buildMenuButton(
                pathMenu: controllerAudit.reference.value.isEmpty ? "" : '/audit/admin',
                image: "assets/images/res.png",
                label: "Ressources",
              )),
              const SizedBox(height: 5),
              const _Divider(),
              Obx(() => _buildMenuButton(
                pathMenu: controllerAudit.reference.value.isEmpty ? "/pilotage" : '/pilotage',
                image: "assets/images/retour_pilotage.jpg",
                label: "Pilotage",
              )),
              const SizedBox(height: 5),
              Obx(() => _buildMenuButton(
                pathMenu: controllerAudit.reference.value.isEmpty ? "/audit/transite" : '/audit/transite',
                image: "assets/images/retour.jpg",
                label: "Audit",
              )),
              const SizedBox(height: 5),
              Obx(() => _buildMenuButton(
                pathMenu: controllerAudit.reference.value.isEmpty ? "" : '',
                image: "assets/images/retour_rapport.jpg",
                label: "Rapport",
              )),
              const SizedBox(height: 5),
              const _Divider(),
              Obx(() => _buildMenuButton(
                pathMenu: controllerAudit.reference.value.isEmpty ? "/" : '/',
                image: "assets/images/return.png",
                label: "Accueil Général",
              )),
              const SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton({required String pathMenu, required String image, required String label, VoidCallback? onTap}) {
    return CustomMenuButton(
      pathMenu: pathMenu,
      image: image,
      label: label,
      isFullPath: false,
      onTap: onTap,
    );
  }
}

class _Header extends StatelessWidget {
  final VoidCallback onDialogRequest;

  const _Header({required this.onDialogRequest});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 11.3),
            child: Container(
              width: 200,
              decoration: const BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: TextButton(
                onPressed: onDialogRequest,
                child: const Text(
                  "GESTION",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            "Menu Principal",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      padding: const EdgeInsets.all(8),
      child: const Divider(color: Colors.black),
    );
  }
}

class CustomMenuButton extends StatefulWidget {
  final String pathMenu;
  final String image;
  final bool isFullPath;
  final String label;
  final VoidCallback? onTap;

  const CustomMenuButton({
    Key? key,
    required this.label,
    required this.pathMenu,
    required this.isFullPath,
    required this.image,
    this.onTap,
  }) : super(key: key);

  @override
  State<CustomMenuButton> createState() => _CustomMenuButtonState();
}

class _CustomMenuButtonState extends State<CustomMenuButton> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      onTap: () {
        widget.onTap?.call();
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
          color: _isHovering ? const Color(0xFFEEEEEE) : Colors.transparent,
          borderRadius: const BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
        ),
        child: OutlinedButton(
          onPressed: () {
            widget.onTap?.call();
            context.go(widget.pathMenu);
          },
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.transparent,
            side: BorderSide.none,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
            ),
          ),
          child: Row(
            children: [
              Image.asset(widget.image, width: 30),
              const SizedBox(width: 18),
              Text(
                widget.label,
                style: TextStyle(fontSize: 18, overflow: TextOverflow.ellipsis, color: _isHovering ? const Color(0xFF114693) : Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
