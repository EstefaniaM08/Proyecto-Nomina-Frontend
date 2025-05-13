import 'package:flutter/material.dart';
import '../services/api_service.dart';

class RegistroEmpleadoViewModel extends ChangeNotifier {
  List<Map<String, dynamic>> areas = [];
  List<Map<String, dynamic>> cargos = [];
  List<Map<String, dynamic>> bancos = [];
  List<Map<String, dynamic>> epsList = [];
  List<Map<String, dynamic>> pensiones = [];
  List<Map<String, dynamic>> contratos = [];

  /// Cargar combos desde API
  Future<void> cargarCombos() async {
    try {
      final data = await ApiService.cargarCombos();
      areas = data['areas'] ?? [];
      cargos = data['cargos'] ?? [];
      bancos = data['bancos'] ?? [];
      epsList = data['eps'] ?? [];
      pensiones = data['pensiones'] ?? [];
      contratos = data['contratos'] ?? [];
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  /// Registrar empleado enviando un mapa con los datos
  Future<bool> registrarEmpleadoConDatos(Map<String, dynamic> empleado) async {
    return await ApiService.registrarEmpleado(empleado);
  }
}
