// lib/viewmodels/login_viewmodel.dart
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/usuario.dart';

class LoginViewModel extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String mensaje = '';
  bool cargando = false;

  Future<void> login(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      mensaje = 'Por favor ingrese su correo y contraseña.';
      notifyListeners();
      return;
    }

    cargando = true;
    notifyListeners();

    try {
      final usuario = Usuario(email: email, password: password);
      final resultado = await ApiService.login(usuario);

      if (resultado != null) {
        mensaje = 'Inicio de sesión exitoso.';
        Navigator.pushReplacementNamed(context, '/menu');
      } else {
        mensaje = 'Credenciales incorrectas.';
      }
    } catch (e) {
      mensaje = 'Error al iniciar sesión.';
    } finally {
      cargando = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
