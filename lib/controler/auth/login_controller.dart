import 'package:flutter/material.dart';
import 'package:flutter_application_1/view/home.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
class LoginController  extends GetxController{
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  var isLoading = false.obs;


  Future<void>login()async{


    var response = await http.post(
      Uri.parse("http://10.0.2.2/web/flutter_app_and_backend/auth/login.php"),
      body: {
        "email": emailController.text,
        "password": passwordController.text
      }

    );

    if(response.statusCode == 200){
      var data = jsonDecode(response.body);
      if(data["status"] == "success"){
        Get.snackbar("نجاح", "تم تسجيل الدخول بنجاح",snackPosition: SnackPosition.BOTTOM,backgroundColor: Colors.green);
        Get.offAll(()=> HomePage());
        
      }
      else{
        Get.snackbar("خطأ", data["message"].toString(),snackPosition: SnackPosition.BOTTOM,backgroundColor: Colors.red);
      }
      
    }else{
      Get.snackbar("خطاء", "حدث خطاء",snackPosition: SnackPosition.BOTTOM,backgroundColor: const Color.fromARGB(255, 255, 0, 140));
    }
  }
}