import 'package:flutter/material.dart';
import '../services/api.dart';

class LoginProvider extends ChangeNotifier {
  
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

 Future<bool> login() async {
    //ok or not
    if (!formKey.currentState!.validate()) return false;
    try {
      await ApiService.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      return true;
    } catch (_) {
      return false;
    }
  }

@override
void dispose() {
  emailController.dispose();
  passwordController.dispose();
  super.dispose();
}

}