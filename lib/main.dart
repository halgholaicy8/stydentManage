import 'package:flutter/material.dart';
import 'package:flutter_application_1/view/home.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/view/auth/login_screen.dart';
import 'package:flutter_application_1/view/students_list_page.dart';
import 'package:flutter_application_1/view/add_student_page.dart';
import 'package:flutter_application_1/view/student_details_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      getPages: [
        GetPage(name: '/login', page: () => LoginScreen()),  
        GetPage(name: '/home', page: () => HomePage()),
        GetPage(name: '/studentsList', page: () => StudentsListPage()),
        GetPage(name: '/addStudent', page: () => AddStudentPage()),
        GetPage(name: '/studentDetails',
          page: () {
            int studentId = Get.arguments ?? 1;
            return StudentDetailsPage(studentId: studentId);
          },
        ),
      ],
    );
  }
}
