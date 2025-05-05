import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/usuario.dart';

class LoginViewModel extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool cargando = false;
  String mensaje = '';

  Future<bool> login() async {
    if (!formKey.currentState!.validate()) return false;

    cargando = true;
    mensaje = '';
    notifyListeners();

    final usuario = Usuario(
      email: emailController.text.trim(),
      password: passwordController.text,
    );

    try {
      final usuarioAutenticado = await ApiService.login(usuario);

      if (usuarioAutenticado == null) {
        mensaje = "❌ Credenciales incorrectas";
        return false;
      }

      return true;
    } catch (e) {
      mensaje = "❌ Error: ${e.toString()}";
      return false;
    } finally {
      cargando = false;
      notifyListeners();
    }
  }

  String? validarEmail(String? value) {
    if (value == null || value.isEmpty) return "El correo es obligatorio";
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) return "Ingrese un correo válido";
    return null;
  }

  String? validarPassword(String? value) {
    if (value == null || value.isEmpty) return "La contraseña es obligatoria";
    return null;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
