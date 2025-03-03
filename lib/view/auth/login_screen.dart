import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/controler/auth/login_controller.dart';
import 'package:flutter_application_1/view/auth/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // مفتاح النموذج للتحقق من صحة المدخلات
  final _formKey = GlobalKey<FormState>();
  // حالة ظهور كلمة المرور
  bool isPasswordVisible = false;
  
  // استدعاء LoginController من GetX
  final LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan.shade50,
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: const Text(
          "Login",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                "Sign In",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal),
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: loginController.emailController,
                label: "Email",
                hint: "Enter your email",
                icon: Icons.email,
                isEmail: true,
              ),
              const SizedBox(height: 10),
              _buildTextField(
                controller: loginController.passwordController,
                label: "Password",
                hint: "Enter your password",
                icon: Icons.lock,
                isPassword: true,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      loginController.login();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyan,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Sign In",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildSignUpLink(),
            ],
          ),
        ),
      ),
    );
  }

  // دالة لبناء العنوان
  Widget u() => Text(
        'Welcome Back!',
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: Colors.blue.shade800,
        ),
      );

  // دالة لبناء حقل النص مع التحقق والتصميم المخصص
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool isEmail = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? !isPasswordVisible : false,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter your $label";
        }
        if (isEmail && !value.contains('@gmail.com')) {
          return "Enter a valid email address";
        }
        if (isPassword && value.length < 8) {
          return "Password must be at least 8 characters long";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.teal),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.teal, width: 2),
        ),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.teal,
                ),
                onPressed: () {
                  setState(() {
                    isPasswordVisible = !isPasswordVisible;
                  });
                },
              )
            : null,
      ),
    );
  }

  // دالة لبناء رابط صفحة التسجيل
  Widget _buildSignUpLink() {
    return TextButton(
      onPressed: () {
        Get.to(() => const SignUpScreen());
      },
      child: Text(
        "Don't have an account? Sign UP",
        style: TextStyle(color: Colors.blue.shade800, fontSize: 16),
      ),
    );
  }
}
