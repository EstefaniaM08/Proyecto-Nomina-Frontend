import 'dart:convert';
import 'package:http/http.dart' as http;
import 'usuario.dart';

/// Función para iniciar sesión
Future<bool> loginUsuario(Usuario usuario) async {
  final response = await http.post(
    Uri.parse('http://10.0.2.2:8080/login/verificar'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(usuario.toJson()),
  );

  if (response.statusCode == 200) {
    final token = response.body;
    if (token != "FAIL") {
      return true; // login exitoso
    } else {
      return false; // credenciales incorrectas
    }
  } else {
    throw Exception('Error al hacer login');
  }
}

/// 🆕 Función para registrar nuevo usuario
Future<String> registrarUsuario(String email, String password) async {
  final url = Uri.parse('http://10.0.2.2:8080/usuarios/registrar-usuario');

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      "email": email,
      "password": password,
    }),
  );

  if (response.statusCode == 200) {
    final respuesta = response.body;

    if (respuesta.contains("correo")) {
      return "correo_existente";
    } else {
      return "ok";
    }
  } else {
    throw Exception("Error al registrar usuario");
  }
}
