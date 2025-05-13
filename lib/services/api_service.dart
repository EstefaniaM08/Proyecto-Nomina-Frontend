import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/usuario.dart';

class ApiService {
  //static const String baseUrl = 'https://proyecto-nomina-backend.onrender.com';
  static const String baseUrl = 'http://10.0.2.2:8080';

  /// Iniciar sesión
  static Future<Usuario?> login(Usuario usuario) async {
    final response = await http.post(
      Uri.parse('$baseUrl/administrador/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(usuario.toJson()),
    );

    if (response.statusCode == 200) {
      final token = response.body;
      if (token != "FAIL") {
        return usuario;
      }
    }
    return null;
  }

  /// Registrar usuario
  static Future<String> registrarUsuario(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/administrador/registrar'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return utf8.decode(response.bodyBytes);
    } else {
      throw Exception('Error al registrar usuario');
    }
  }

  /// Registrar empleado
  static Future<bool> registrarEmpleado(Map<String, dynamic> empleado) async {
    final response = await http.post(
      Uri.parse('$baseUrl/personal/registrar-persona'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(empleado),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('❌ Error en el registro: ${utf8.decode(response.bodyBytes)}');
      return false;
    }
  }

  /// Buscar empleados
  static Future<List<Map<String, dynamic>>> buscarEmpleados(Map<String, dynamic> filtros) async {
    final uri = Uri.parse('$baseUrl/personal/busqueda-personas').replace(queryParameters: filtros.map((key, value) => MapEntry(key, value.toString())));

    final response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Error al buscar empleados');
    }
  }


  /// Cargar todos los combos (áreas, cargos, etc.)
  static Future<Map<String, List<Map<String, dynamic>>>> cargarCombos() async {
    final urls = {
      'areas': '$baseUrl/cargar/areas',
      'cargos': '$baseUrl/cargar/cargos',
      'bancos': '$baseUrl/cargar/bancos',
      'eps': '$baseUrl/cargar/eps',
      'pensiones': '$baseUrl/cargar/pensiones',
      'contratos': '$baseUrl/cargar/contratos',
    };

    try {
      final responses = await Future.wait(
        urls.values.map((url) => http.get(Uri.parse(url))),
      );

      return {
        'areas': List<Map<String, dynamic>>.from(jsonDecode(utf8.decode(responses[0].bodyBytes))),
        'cargos': List<Map<String, dynamic>>.from(jsonDecode(utf8.decode(responses[1].bodyBytes))),
        'bancos': List<Map<String, dynamic>>.from(jsonDecode(utf8.decode(responses[2].bodyBytes))),
        'eps': List<Map<String, dynamic>>.from(jsonDecode(utf8.decode(responses[3].bodyBytes))),
        'pensiones': List<Map<String, dynamic>>.from(jsonDecode(utf8.decode(responses[4].bodyBytes))),
        'contratos': List<Map<String, dynamic>>.from(jsonDecode(utf8.decode(responses[5].bodyBytes))),
      };
    } catch (e) {
      print('❌ Error cargando combos: $e');
      rethrow;
    }
  }
}
