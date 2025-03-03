import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class EditStudentPage extends StatefulWidget {
  final Map student;
  EditStudentPage({required this.student});

  @override
  _EditStudentPageState createState() => _EditStudentPageState();
}

class _EditStudentPageState extends State<EditStudentPage> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController addressController;
  late TextEditingController academicController;
  late TextEditingController majorController;
  late TextEditingController levelController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.student['name'] ?? '');
    emailController = TextEditingController(text: widget.student['email'] ?? '');
    phoneController = TextEditingController(text: widget.student['phone'] ?? '');
    addressController = TextEditingController(text: widget.student['address'] ?? '');
    academicController = TextEditingController(text: widget.student['academic_average']?.toString() ?? '');
    majorController = TextEditingController(text: widget.student['major'] ?? '');
    levelController = TextEditingController(text: widget.student['level'] ?? '');
  }

  Future<void> updateStudent() async {
    String studentId = widget.student['id'].toString();
    if (studentId.isEmpty) {
      Get.snackbar("خطأ", "معرّف الطالب مفقود", backgroundColor: Colors.red);
      return;
    }

    var url = Uri.parse("http://10.0.2.2/web/flutter_app_and_backend/view/updateStudent.php");
    var response = await http.post(url, body: {
      'id': studentId,
      'name': nameController.text,
      'email': emailController.text,
      'phone': phoneController.text,
      'address': addressController.text,
      'academic_average': academicController.text,
      'major': majorController.text,
      'level': levelController.text,
    });

    print("Response: ${response.body}");

    var data = json.decode(response.body);
    if (data['success']) {
      Get.snackbar("نجاح", "تم تحديث بيانات الطالب بنجاح",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green);
      Get.back(result: true);
    } else {
      Get.snackbar("خطأ", data['message'],
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تعديل بيانات الطالب'),
        backgroundColor: Colors.cyan.shade800,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  buildTextField(nameController, 'الاسم', Icons.person),
                  buildTextField(emailController, 'البريد الإلكتروني', Icons.email),
                  buildTextField(phoneController, 'رقم الهاتف', Icons.phone),
                  buildTextField(addressController, 'العنوان', Icons.home),
                  buildTextField(academicController, 'المعدل الأكاديمي', Icons.grade, isNumber: true),
                  buildTextField(majorController, 'التخصص', Icons.book),
                  buildTextField(levelController, 'المستوى', Icons.school),
                ],
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: updateStudent,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyan.shade800,
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text('تحديث', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, String label, IconData icon, {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.cyan.shade800),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.cyan.shade800, width: 2),
          ),
        ),
      ),
    );
  }
}
