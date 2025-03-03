import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'student_details_page.dart';
import 'add_student_page.dart';

class StudentsController extends GetxController {
  var students = [].obs;
  var isLoading = true.obs; // حالة التحميل

  @override
  void onInit() {
    fetchStudents();
    super.onInit();
  }

  Future<void> fetchStudents() async {
    isLoading.value = true; // بدء التحميل
    var url = Uri.parse('http://10.0.2.2/web/flutter_app_and_backend/view/getStudents.php');
    var response = await http.get(url);
    
    if (response.statusCode == 200) {
      students.value = json.decode(response.body);
    }
    
    isLoading.value = false; // انتهاء التحميل
  }

  void deleteStudent(int id) async {
    bool? confirmDelete = await Get.dialog(
      AlertDialog(
        title: Text("تأكيد الحذف"),
        content: Text("هل أنت متأكد من حذف هذا الطالب؟"),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false), // إلغاء
            child: Text("إلغاء"),
          ),
          TextButton(
            onPressed: () => Get.back(result: true), // تأكيد
            child: Text("حذف", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmDelete == true) {
      var url = Uri.parse('http://10.0.2.2/web/flutter_app_and_backend/view/deleteStudent.php');
      var response = await http.post(url, body: {'id': id.toString()});
      var data = json.decode(response.body);

      if (data['success']) {
        fetchStudents();
        Get.snackbar("نجاح", "تم حذف الطالب بنجاح", backgroundColor: Colors.green);
      } else {
        Get.snackbar("خطأ", data['message'], backgroundColor: Colors.red);
      }
    }
  }
}

class StudentsListPage extends StatelessWidget {
  final StudentsController controller = Get.put(StudentsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('قائمة الطلاب', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.cyan.shade800,
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator()); // أثناء تحميل البيانات
        }

        if (controller.students.isEmpty) {
          return Center(
            child: Text(
              "لا يوجد طلاب مسجلين حاليًا",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black54),
            ),
          ); // عرض الرسالة عند عدم وجود طلاب
        }

        return ListView.builder(
          itemCount: controller.students.length,
          padding: EdgeInsets.all(10),
          itemBuilder: (context, index) {
            var student = controller.students[index];
            int studentId = int.parse(student['id'].toString());

            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.cyan.shade800,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                title: Text(student['name'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                subtitle: Text(student['email'], style: TextStyle(color: Colors.black54)),
                onTap: () {
                  Get.to(() => StudentDetailsPage(studentId: studentId));
                },
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => controller.deleteStudent(studentId),
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => AddStudentPage())?.then((_) => controller.fetchStudents());
        },
        backgroundColor: Colors.cyan.shade800,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
