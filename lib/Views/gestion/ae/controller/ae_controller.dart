import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
//import 'package:perfqse/Views/gestion/widgets/dashboard_gestion.dart';

import '../../../../../models/common/user_model.dart';
import '../../../../../models/pilotage/acces_pilotage_model.dart';

class AeController extends GetxController{
  final storage = FlutterSecureStorage();
  var aAfficher=1.obs;

  @override
  void onInit() {
    aAfficher.value=1;
    super.onInit();
  }
}