import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:perfqse/Views/audit/controller/controller_audit.dart';

class DashboardGestion extends StatefulWidget {
  const DashboardGestion({super.key});

  @override
  State<DashboardGestion> createState() => _DashboardGestionState();
}

class _DashboardGestionState extends State<DashboardGestion> {
  final ControllerAudit controllerAudit = Get.put(ControllerAudit());
  final storage = FlutterSecureStorage();
  final String location = "/gestion/accueil";

  bool isHoveredQSE = false;
  bool isHoveredQ = false;
  bool isHoveredS = false;

  bool _showInfo = false; // State to control the visibility of the information widget
  Offset _infoPosition = Offset.zero; // Position of the information widget
  String _infoText = ''; // Text of the information widget

  final GlobalKey _keyE = GlobalKey();
  final GlobalKey _keyQ = GlobalKey();
  final GlobalKey _keyS = GlobalKey();

  final Map<String, String> buttonInfo = {
    'keyE': "Je suis le bouton Er\nrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr\nrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr",
    'keyQ': "I'm the Q button",
    'keyS': "Helloooo!!! It'es me S",
  };
  String _activeKey = '';

  Future<void> _showDialogNoAcces() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Accès refusé'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Vous n'avez pas la référence d'accès à cet espace."),
                SizedBox(height: 20),
                Image.asset(
                  "assets/images/forbidden.png",
                  width: 50,
                  height: 50,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void getAccess(String centerTitle) async {
    String? reference = await storage.read(key: "ref");
    List<String> ref = ["QX", "SX"]; // ["Q", "S", "E", "QSE"]
    if (reference != null) {
      ref = reference.split("\n");
    }
    if (ref.contains(centerTitle)) {
      controllerAudit.reference.value = centerTitle;
      context.go(location);
    } else {
      _showDialogNoAcces();
    }
  }

  void _showInformation(Offset position, String infoText) {
    setState(() {
      _showInfo = true;
      _infoPosition = position;
      _infoText = infoText;
    });
  }

  void _hideInformation() {
    setState(() {
      _showInfo = false;
    });
  }

  void _handleButtonTap(String key, GlobalKey buttonKey) {
    final RenderBox? renderBox = buttonKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final Offset buttonPosition = renderBox.localToGlobal(renderBox.size.centerLeft(Offset.zero));
      final String infoText = buttonInfo[key] ?? 'Aucune information disponible';
      _showInformation(buttonPosition, infoText);
      setState(() {
        _activeKey = key;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: _hideInformation,
        child: Stack(
          children: [
            // Full-screen GestureDetector to hide information when clicking outside
            Positioned.fill(
              child: GestureDetector(
                onTap: _hideInformation,
                child: Container(color: Colors.transparent),
              ),
            ),
            Positioned(
              top: 160,
              right: 490,
              child: SizedBox(
                height: 250,
                width: 250,
                child: InkWell(
                  onTap: () {
                    context.go("/gestion/profil");
                  },
                  mouseCursor: SystemMouseCursors.click,
                  child: Image.asset("assets/images/user-profile.png", fit: BoxFit.contain),
                ),
              ),
            ),
            Positioned(
              top: 160,
              right: 490,
              child: SizedBox(
                height: 250,
                width: 250,
                child: InkWell(
                  key: _keyS,
                  onTap: () {
                    _handleButtonTap('keyS', _keyS);
                  },
                  mouseCursor: SystemMouseCursors.click,
                  child: Image.asset("assets/images/qse.png", fit: BoxFit.contain),
                ),
              ),
            ),
            // Main content with images and dropdown menus
            Positioned(
              bottom: 35,
              right: 460,
              child: SizedBox(
                height: 200,
                width: 300,
                child: InkWell(
                  key: _keyE,
                  onTap: () => _handleButtonTap('keyE', _keyE),
                  mouseCursor: SystemMouseCursors.click,
                  child: Image.asset("assets/images/e.png", fit: BoxFit.contain),
                ),
              ),
            ),
            Positioned(
              top: 130,
              left: 60,
              child: SizedBox(
                height: 160,
                width: 300,
                child: InkWell(
                  key: _keyQ,
                  onTap: () => _handleButtonTap('keyQ', _keyQ),
                  mouseCursor: SystemMouseCursors.click,
                  child: Image.asset("assets/images/q.png", fit: BoxFit.contain),
                ),
              ),
            ),
            Positioned(
              top: 130,
              right: 50,
              child: SizedBox(
                height: 160,
                width: 300,
                child: InkWell(
                  key: _keyS,
                  onTap: () => _handleButtonTap('keyS', _keyS),
                  mouseCursor: SystemMouseCursors.click,
                  child: Image.asset("assets/images/s.png", fit: BoxFit.contain),
                ),
              ),
            ),
            // QSE Dropdown
            Positioned(
              top: 30,
              right: 480,
              child: MouseRegion(
                onEnter: (_) {
                  setState(() {
                    isHoveredQSE = true;
                  });
                },
                onExit: (_) {
                  setState(() {
                    isHoveredQSE = false;
                  });
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  height: isHoveredQSE ? 390 : 45,
                  width: 275,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                            ),
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            "Gestion de l'entreprise",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        if (isHoveredQSE)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              children: [
                                SizedBox(
                                  width: 245, // Fixed width for buttons
                                  child: ElevatedButton(
                                    onPressed: () {
                                      getAccess("QSE");
                                    },
                                    child: Text("Fonctionnement de l'entreprise"),
                                  ),
                                ),
                                SizedBox(height: 10),
                                SizedBox(
                                  width: 245, // Fixed width for buttons
                                  child: ElevatedButton(
                                    onPressed: () {
                                      getAccess("QSE");
                                    },
                                    child: Text("Responsabilités et autorités"),
                                  ),
                                ),
                                SizedBox(height: 10),
                                SizedBox(
                                  width: 245, // Fixed width for buttons
                                  child: ElevatedButton(
                                    onPressed: () {
                                      getAccess("QSE");
                                    },
                                    child: Text("Le personnel"),
                                  ),
                                ),
                                SizedBox(height: 10),
                                SizedBox(
                                  width: 245, // Fixed width for buttons
                                  child: ElevatedButton(
                                    onPressed: () {
                                      getAccess("QSE");
                                    },
                                    child: Text("Gestion du personnel"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Q Dropdown
            Positioned(
              top: 30,
              left: 60,
              child: MouseRegion(
                onEnter: (_) {
                  setState(() {
                    isHoveredQ = true;
                  });
                },
                onExit: (_) {
                  setState(() {
                    isHoveredQ = false;
                  });
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  height: isHoveredQ ? 270 : 45,
                  width: 300,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                            ),
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            "Gestion SM QSE",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        if (isHoveredQ)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              children: [
                                SizedBox(
                                  width: 245, // Fixed width for buttons
                                  child: ElevatedButton(
                                    onPressed: () {
                                      getAccess("Q");
                                    },
                                    child: Text("Questions fréquentes"),
                                  ),
                                ),
                                SizedBox(height: 10),
                                SizedBox(
                                  width: 245, // Fixed width for buttons
                                  child: ElevatedButton(
                                    onPressed: () {
                                      getAccess("Q");
                                    },
                                    child: Text("Questions générales"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // S Dropdown
            Positioned(
              top: 30,
              right: 50,
              child: MouseRegion(
                onEnter: (_) {
                  setState(() {
                    isHoveredS = true;
                  });
                },
                onExit: (_) {
                  setState(() {
                    isHoveredS = false;
                  });
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  height: isHoveredS ? 250 : 45,
                  width: 275,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                            ),
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            "Gestion des services",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        if (isHoveredS)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              children: [
                                SizedBox(
                                  width: 245, // Fixed width for buttons
                                  child: ElevatedButton(
                                    onPressed: () {
                                      getAccess("S");
                                    },
                                    child: Text("Services disponibles"),
                                  ),
                                ),
                                SizedBox(height: 10),
                                SizedBox(
                                  width: 245, // Fixed width for buttons
                                  child: ElevatedButton(
                                    onPressed: () {
                                      getAccess("S");
                                    },
                                    child: Text("Service clientèle"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Information widget
            if (_showInfo)
              Positioned(
                top: _infoPosition.dy,
                left: _infoPosition.dx,
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _infoText,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
