import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import '../models/usuario.dart';
import 'package:http_parser/http_parser.dart';

class ApiService {
  static const String baseUrl = 'https://proyecto-nomina-backend.onrender.com';
  //static const String baseUrl = 'http://10.0.2.2:8080';

  /// Iniciar sesión
  static Future<Usuario?> login(Usuario usuario) async {
    final response = await http.post(
      Uri.parse('$baseUrl/administrador/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(usuario.toJson()),
    );
    if (response.statusCode == 200 && response.body != "FAIL") {
      return usuario;
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
    if (response.statusCode == 200) return true;
    print('❌ Error en el registro: ${utf8.decode(response.bodyBytes)}');
    return false;
  }

  /// Buscar empleados
  static Future<List<Map<String, dynamic>>> buscarEmpleados(
    Map<String, dynamic> filtros,
  ) async {
    final uri = Uri.parse('$baseUrl/personal/busqueda-personas').replace(
      queryParameters: filtros.map(
        (key, value) => MapEntry(key, value.toString()),
      ),
    );
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

  /// Cargar combos (áreas, cargos, etc.)
  static Future<Map<String, List<Map<String, dynamic>>>> cargarCombos() async {
    final urls = {
      'areas': '$baseUrl/cargar/areas',
      'cargos': '$baseUrl/cargar/cargos',
      'bancos': '$baseUrl/cargar/bancos',
      'eps': '$baseUrl/cargar/eps',
      'pensiones': '$baseUrl/cargar/pensiones',
      'contratos': '$baseUrl/cargar/contratos',
    };
    final responses = await Future.wait(
      urls.values.map((url) => http.get(Uri.parse(url))),
    );
    return {
      'areas': List<Map<String, dynamic>>.from(
        jsonDecode(utf8.decode(responses[0].bodyBytes)),
      ),
      'cargos': List<Map<String, dynamic>>.from(
        jsonDecode(utf8.decode(responses[1].bodyBytes)),
      ),
      'bancos': List<Map<String, dynamic>>.from(
        jsonDecode(utf8.decode(responses[2].bodyBytes)),
      ),
      'eps': List<Map<String, dynamic>>.from(
        jsonDecode(utf8.decode(responses[3].bodyBytes)),
      ),
      'pensiones': List<Map<String, dynamic>>.from(
        jsonDecode(utf8.decode(responses[4].bodyBytes)),
      ),
      'contratos': List<Map<String, dynamic>>.from(
        jsonDecode(utf8.decode(responses[5].bodyBytes)),
      ),
    };
  }

  /// Generar nómina
  static Future<Map<String, dynamic>> pagarNomina(
    Map<String, dynamic> data,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/pagonomina/pago-nomina'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception(
        'Error al generar nómina: ${utf8.decode(response.bodyBytes)}',
      );
    }
  }

  /// Obtener empleado por identificación
  static Future<Map<String, dynamic>> obtenerEmpleadoPorIdentificacion(
    String id,
  ) async {
    final response = await http.get(
      Uri.parse('$baseUrl/personal/buscar-persona/$id'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception(
        'Empleado no encontrado: ${utf8.decode(response.bodyBytes)}',
      );
    }
  }

  /// Actualizar empleado
  static Future<void> actualizarEmpleado(Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/personal/actualizar-persona'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (response.statusCode != 200) {
      throw Exception(
        'Error al actualizar empleado: ${utf8.decode(response.bodyBytes)}',
      );
    }
  }

  /// Desactivar empleado
  static Future<void> desactivarEmpleado(dynamic id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/personal/desactivar-persona/$id'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 200) {
      throw Exception(
        'Error al desactivar empleado: ${utf8.decode(response.bodyBytes)}',
      );
    }
  }

  /// Buscar nóminas
  static Future<List<Map<String, dynamic>>> buscarNominas(
    Map<String, dynamic> filtros,
  ) async {
    final uri = Uri.parse('$baseUrl/pagonomina/busqueda-nominas').replace(
      queryParameters: filtros.map(
        (key, value) => MapEntry(key, value.toString()),
      ),
    );
    final response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Error al buscar nóminas');
    }
  }

  /// Descargar y abrir PDF de desprendible de nómina
  static Future<void> descargarYMostrarPDF(
    Map<String, dynamic> payload,
    BuildContext context,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/pagonomina/crear-pdf'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;

        // Usar almacenamiento temporal interno (no requiere permisos)
        final dir = await getTemporaryDirectory();
        final file = File(
          '${dir.path}/desprendible_${payload["cedula"]}_${payload["fecha"]}.pdf',
        );
        await file.writeAsBytes(bytes);

        // Mostrar mensaje y abrir el archivo
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('PDF generado con éxito')));

        await OpenFile.open(file.path);
      } else {
        throw Exception(
          'Error al generar desprendible: ${utf8.decode(response.bodyBytes)}',
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  static Future<void> exportarExcelNominas(Map<String, dynamic> filtros) async {
    try {
      final uri = Uri.parse('$baseUrl/pagonomina/exportar-excel').replace(
        queryParameters: filtros.map(
          (key, value) => MapEntry(key, value.toString()),
        ),
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;

        // ✅ Guardar en almacenamiento interno temporal
        final dir = await getTemporaryDirectory();
        final file = File('${dir.path}/nominas_exportadas.xlsx');
        await file.writeAsBytes(bytes);

        // ✅ Abrir con la app predeterminada (Excel, WPS, etc.)
        await OpenFile.open(file.path);
      } else {
        throw Exception('Error al exportar Excel');
      }
    } catch (e) {
      print('❌ $e');
      rethrow;
    }
  }

  static Future<void> generarNominaDesdeExcel(
    File excelFile,
    BuildContext context,
  ) async {
    final uri = Uri.parse('$baseUrl/pagonomina/pago-nomina/excel');
    final request = http.MultipartRequest('POST', uri);

    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        excelFile.path,
        contentType: MediaType(
          'application',
          'vnd.openxmlformats-officedocument.spreadsheetml.sheet',
        ),
      ),
    );

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Nómina generada exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        final responseBody = await response.stream.bytesToString();
        String mensajeError = '❌ Error al generar nómina';

        try {
          final decoded = jsonDecode(responseBody);
          if (decoded is Map<String, dynamic>) {
            mensajeError = decoded['message'] ??
                decoded['error'] ??
                decoded['path'] ??
                mensajeError;
          }
        } catch (_) {
          mensajeError = responseBody;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error al generar nómina: $mensajeError'),
            backgroundColor: Colors.red.shade400,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Error de conexión: $e'),
          backgroundColor: Colors.red.shade400,
        ),
      );
    }
  }
}
