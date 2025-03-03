import 'package:flutter/material.dart';
import 'package:flutter_application_1/view/home.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class SignupController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  var isLoading = false.obs;

 Future<void> signup({required String name, required String email, required String password}) async {
  var response = await http.post(
    Uri.parse("http://10.0.2.2/web/flutter_app_and_backend/auth/signup.php"),
    body: {
      "name": name,
      "email": email,
      "password": password,
    },
  );

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    if (data["status"] == "success") {
      Get.snackbar("نجاح", "تم  إنشاء الحساب سجل الدخول",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green);
      Get.offAll(() => HomePage());
    } else {
      Get.snackbar("خطأ", data["message"],
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
    }
  } else {
    Get.snackbar("خطاء", "حدث خطاء",
        snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.purple);
  }
}

}
