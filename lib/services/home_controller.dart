import 'dart:convert';

import 'package:adviceMe/model/advice.dart';
import 'package:adviceMe/services/advice_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  // ignore: deprecated_member_use
  // var adviceList = List<Advice>().obs;
  @override
  void onInit() {
    _getAdvice();
    super.onInit();
  }

  void _getAdvice() async {
    Future.delayed(
        Duration.zero,
        () => Get.dialog(Center(child: CircularProgressIndicator()),
            barrierDismissible: false));

    Request request = Request(
      endpoint,
    );
    request.get().then((value) {
      return Advice.fromJson(json.decode(value.body));

      // Get.back();
    }).catchError((onError) {
      print(onError);
    });
  }
}
