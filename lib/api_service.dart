import 'dart:convert';
import 'package:http/http.dart' as http;
import 'usuario.dart';

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
