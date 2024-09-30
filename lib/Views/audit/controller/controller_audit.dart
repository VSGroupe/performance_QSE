import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ControllerAudit extends GetxController{
  var reference="".obs;
  var currentGestAudit=0.obs;
  var currentPage = "".obs;

  @override
  void onInit() {
   reference.value="";
   currentPage.value="";
   currentGestAudit.value=0;
    super.onInit();
  }

}