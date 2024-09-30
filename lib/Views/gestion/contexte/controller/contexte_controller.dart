import 'package:get/get.dart';

import '../../../../../models/common/user_model.dart';

class ContexteController extends GetxController{
  var aRafraichir = 0.obs;

  @override
  void onInit() {
    aRafraichir.value=0;
    super.onInit();
  }
}