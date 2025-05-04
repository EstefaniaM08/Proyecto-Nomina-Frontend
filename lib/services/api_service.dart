// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/usuario.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8080';

  /// Iniciar sesión
  static Future<Usuario?> login(Usuario usuario) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login/verificar'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(usuario.toJson()),
    );

    if (response.statusCode == 200) {
      final token = response.body;
      if (token != "FAIL") {
        return usuario; // autenticación exitosa
      }
    }
    return null;
  }

  /// Registrar usuario
  static Future<String> registrarUsuario(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/usuarios/registrar-usuario'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Error al registrar usuario');
    }
  }

  /// Obtener listas como áreas, cargos, bancos, etc.
  static Future<List<Map<String, dynamic>>> obtenerLista(String entidad) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$entidad'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Error al obtener $entidad');
    }
  }

  /// Registrar empleado
  static Future<bool> registrarEmpleado(Map<String, dynamic> empleado) async {
    final response = await http.post(
      Uri.parse('$baseUrl/empleados/registrar'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(empleado),
    );

    return response.statusCode == 200;
  }

  /// Buscar empleados
  static Future<List<Map<String, dynamic>>> buscarEmpleados(Map<String, dynamic> filtros) async {
    final response = await http.post(
      Uri.parse('$baseUrl/personal/busqueda-personas'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(filtros),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Error al buscar empleados');
    }
  }
}
