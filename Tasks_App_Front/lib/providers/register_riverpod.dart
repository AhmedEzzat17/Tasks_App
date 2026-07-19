import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api.dart';

final registerProvider = Provider.autoDispose<RegisterLogic>((ref) {
  final logic = RegisterLogic();
  ref.onDispose(() => logic.dispose());
  return logic;
});

class RegisterLogic {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  Future<bool> register() async {
    if (!formKey.currentState!.validate()) return false;
    try {
      await ApiService.register(
        nameController.text.trim(),
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }
}
