import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'edit_student_page.dart';

class StudentController extends GetxController {
  var student = {}.obs;

  Future<void> fetchStudentDetails(int id) async {
    try {
      var url = Uri.parse('http://10.0.2.2/web/flutter_app_and_backend/view/studentDetails.php?id=$id');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        student.value = json.decode(response.body);
      } else {
        Get.snackbar("خطأ", "فشل في جلب بيانات الطالب", backgroundColor: Colors.red);
      }
    } catch (e) {
      Get.snackbar("خطأ", "حدث خطأ: $e", backgroundColor: Colors.red);
    }
  }

  void updateStudent() {
    if (student.isNotEmpty) {
      fetchStudentDetails(int.parse(student['id'].toString()));
    }
  }
}

class StudentDetailsPage extends StatelessWidget {
  final int studentId;
  final StudentController controller = Get.put(StudentController());

  StudentDetailsPage({required this.studentId}) {
    controller.fetchStudentDetails(studentId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تفاصيل الطالب', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.cyan.shade800,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              if (controller.student.isNotEmpty) {
                Get.to(() => EditStudentPage(student: controller.student))?.then((_) {
                  controller.updateStudent();
                });
              }
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.student.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildInfoCard(Icons.person, 'الاسم', controller.student['name']),
              buildInfoCard(Icons.email, 'البريد الإلكتروني', controller.student['email']),
              buildInfoCard(Icons.phone, 'رقم الهاتف', controller.student['phone']),
              buildInfoCard(Icons.location_on, 'العنوان', controller.student['address']),
              buildInfoCard(Icons.school, 'المعدل الأكاديمي', controller.student['academic_average']),
              buildInfoCard(Icons.menu_book, 'التخصص', controller.student['major']),
              buildInfoCard(Icons.grade, 'المستوى', controller.student['level']),
            ],
          ),
        );
      }),
    );
  }

  Widget buildInfoCard(IconData icon, String label, String value) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.cyan.shade800),
        title: Text(label, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Text(value, style: TextStyle(fontSize: 16, color: Colors.black87)),
      ),
    );
  }
}
