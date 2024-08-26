import 'package:get/get.dart';

class GestionProcessusController extends GetxController{
  var aAfficher=1.obs;

  @override
  void onInit() {
    aAfficher.value=1;
    super.onInit();
  }
}