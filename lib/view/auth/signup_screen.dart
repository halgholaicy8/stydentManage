import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/controler/auth/signup_controller.dart';
import 'package:flutter_application_1/view/auth/login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);
  
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for the sign-up fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // For toggling visibility of password fields
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  // GetX Signup controller
  final SignupController signupController = Get.put(SignupController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan.shade50,
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: const Text(
          "Create Account",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  "Sign Up",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal),
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: nameController,
                  label: "Full Name",
                  hint: "Enter your full name",
                  icon: Icons.person,
                ),
                const SizedBox(height: 10),
                _buildTextField(
                  controller: emailController,
                  label: "Email",
                  hint: "Enter your email",
                  icon: Icons.email,
                  isEmail: true,
                ),
                const SizedBox(height: 10),
                _buildTextField(
                  controller: passwordController,
                  label: "Password",
                  hint: "Enter your password",
                  icon: Icons.lock,
                  isPassword: true,
                ),
                const SizedBox(height: 10),
                _buildTextField(
                  controller: confirmPasswordController,
                  label: "Confirm Password",
                  hint: "Re-enter your password",
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
                        if (passwordController.text != confirmPasswordController.text) {
                          Get.snackbar(
                            "Error", 
                            "Passwords do not match",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                          return;
                        }
                        // Call the signup method from the controller
                      signupController.signup(
                        name: nameController.text,
                        email: emailController.text,
                        password: passwordController.text,
                        );
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
                      "Sign Up",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildLoginLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

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
      obscureText: isPassword
          ? (controller == passwordController ? !isPasswordVisible : !isConfirmPasswordVisible)
          : false,
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
                  controller == passwordController
                      ? (isPasswordVisible ? Icons.visibility : Icons.visibility_off)
                      : (isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off),
                  color: Colors.teal,
                ),
                onPressed: () {
                  setState(() {
                    if (controller == passwordController) {
                      isPasswordVisible = !isPasswordVisible;
                    } else {
                      isConfirmPasswordVisible = !isConfirmPasswordVisible;
                    }
                  });
                },
              )
            : null,
      ),
    );
  }

  Widget _buildLoginLink() {
    return TextButton(
      onPressed: () {
        Get.to(() => const LoginScreen());
      },
      child: Text(
        "Already have an account? Login",
        style: TextStyle(color: Colors.blue.shade800, fontSize: 16),
      ),
    );
  }
}
