import 'package:get/get.dart';

import '../../../../../models/common/user_model.dart';
import '../../../../../models/pilotage/acces_pilotage_model.dart';

class AccueilPilotController extends GetxController{
  var aAfficher=0.obs;

  @override
  void onInit() {
    super.onInit();
    aAfficher.value=0;
  }
}