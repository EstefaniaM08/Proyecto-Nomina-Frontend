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

Future<Map<String, List<Map<String, dynamic>>>> cargarCombos() async {
  final urls = {
    'areas': 'http://10.0.2.2:8080/cargar/areas',
    'cargos': 'http://10.0.2.2:8080/cargar/cargos',
    'bancos': 'http://10.0.2.2:8080/cargar/bancos',
    'eps': 'http://10.0.2.2:8080/cargar/eps',
    'pensiones': 'http://10.0.2.2:8080/cargar/pensiones',
    'contratos': 'http://10.0.2.2:8080/cargar/contratos',
  };

  try {
    final responses = await Future.wait(
      urls.values.map((url) => http.get(Uri.parse(url))),
    );

    return {
      'areas': List<Map<String, dynamic>>.from(jsonDecode(responses[0].body)),
      'cargos': List<Map<String, dynamic>>.from(jsonDecode(responses[1].body)),
      'bancos': List<Map<String, dynamic>>.from(jsonDecode(responses[2].body)),
      'eps': List<Map<String, dynamic>>.from(jsonDecode(responses[3].body)),
      'pensiones': List<Map<String, dynamic>>.from(jsonDecode(responses[4].body)),
      'contratos': List<Map<String, dynamic>>.from(jsonDecode(responses[5].body)),
    };
  } catch (e) {
    print('❌ Error cargando combos: $e');
    rethrow;
  }
}

Future<void> registrarEmpleado({
  required String identificacion,
  required String nombres,
  required String apellidos,
  required String telefono,
  required String correo,
  required String salario,
  required String cuenta,
  required String fechaNac,
  int? idArea,
  int? idCargo,
  int? idBanco,
  int? idEps,
  int? idPension,
  int? idContrato,
}) async {
  final data = {
    "identificacion": identificacion,
    "nombres": nombres,
    "apellidos": apellidos,
    "telefono": telefono,
    "correo": correo,
    "salario": int.parse(salario),
    "cuentaBancaria": cuenta,
    "estado": "Activo",
    "fechaIngreso": DateTime.now().toIso8601String().split('T').first,
    "fechaNac": fechaNac,
    "fechaRetiro": null,
    "cargo": {"id": idCargo},
    "area": {"id": idArea},
    "tipoContrato": {"id": idContrato},
    "banco": {"id": idBanco},
    "eps": {"id": idEps},
    "pensiones": {"id": idPension}
  };

  final response = await http.post(
    Uri.parse('http://10.0.2.2:8080/personal/registrar-persona'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(data),
  );

  if (response.statusCode == 200) {
    print('✅ Registro exitoso');
  } else {
    print('❌ Error: \${response.body}');
  }
}
