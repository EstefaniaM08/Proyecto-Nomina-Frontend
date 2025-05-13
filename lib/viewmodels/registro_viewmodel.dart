import 'package:flutter/material.dart';
import '../services/api_service.dart';

class RegistroViewModel extends ChangeNotifier {
  final emailController = TextEditingController();
  final pass1Controller = TextEditingController();
  final pass2Controller = TextEditingController();

  bool cargando = false;
  bool mostrarPass1 = false;
  bool mostrarPass2 = false;
  String mensaje = '';

  void toggleMostrarPass1() {
    mostrarPass1 = !mostrarPass1;
    notifyListeners();
  }

  void toggleMostrarPass2() {
    mostrarPass2 = !mostrarPass2;
    notifyListeners();
  }

  Future<bool> registrarUsuario(BuildContext context) async {
    cargando = true;
    mensaje = '';
    notifyListeners();

    try {
      final respuesta = await ApiService.registrarUsuario(
        emailController.text.trim(),
        pass1Controller.text,
      );

      if (respuesta == "correo_existente") {
        mensaje = "⚠️ El correo ya está registrado";
        notifyListeners();
        return false;
      } else {
        mensaje = "✅ Usuario registrado con éxito";
        notifyListeners();
        return true;
      }
    } catch (e) {
      mensaje = "❌ Error al registrar usuario";
      notifyListeners();
      return false;
    } finally {
      cargando = false;
      notifyListeners();
    }
  }
}
