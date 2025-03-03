import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/view/students_list_page.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
class AddStudentPage extends StatefulWidget {
  @override
  _AddStudentPageState createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController academicController = TextEditingController();
  final TextEditingController majorController = TextEditingController();
  final TextEditingController levelController = TextEditingController();
  

 Future<void> addStudent() async {
    var url = Uri.parse('http://10.0.2.2/web/flutter_app_and_backend/view/addStudent.php');
    var response = await http.post(url, body: {
      'name': nameController.text,
      'email': emailController.text,
      'phone': phoneController.text,
      'address': addressController.text,
      'academic_average': academicController.text,
      'major': majorController.text,
      'level': levelController.text,
    });

    var data = json.decode(response.body);
    if (data['success']) {
      // العودة إلى الصفحة السابقة باستخدام Get.back()
      Get.to(StudentsListPage());
    } else {
      // عرض رسالة الخطأ باستخدام Get.snackbar
      Get.snackbar(
        "Error", 
        data['message'],
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Student',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.cyan.shade800,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildTextField(nameController, 'Name', Icons.person),
            const SizedBox(height: 10),
            _buildTextField(emailController, 'Email', Icons.email),
            const SizedBox(height: 10),
            _buildTextField(phoneController, 'Phone', Icons.phone),
            const SizedBox(height: 10),
            _buildTextField(addressController, 'Address', Icons.home),
            const SizedBox(height: 10),
            _buildTextField(academicController, 'Academic Average', Icons.grade,
                keyboardType: TextInputType.number),
            const SizedBox(height: 10),
            _buildTextField(majorController, 'Major', Icons.book),
            const SizedBox(height: 10),
            _buildTextField(levelController, 'Level', Icons.school),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: addStudent ,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyan.shade800,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Add Student',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
             ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      IconData icon, {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
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
    );
  }
}
