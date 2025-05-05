import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ConsultaEmpleadosViewModel extends ChangeNotifier {
  List<String> areas = [];
  List<String> cargos = [];
  String? areaSeleccionada;
  String? cargoSeleccionado;

  List<Map<String, dynamic>> resultados = [];

  Future<void> cargarCombos() async {
    try {
      final data = await ApiService.cargarCombos();
      areas = List<String>.from((data['areas'] ?? []).map((e) => e['nombre'].toString()));
      cargos = List<String>.from((data['cargos'] ?? []).map((e) => e['nombre'].toString()));
      notifyListeners();
    } catch (e) {
      debugPrint('Error al cargar combos: \$e');
    }
  }

  Future<void> buscarEmpleados(
    String identificacion,
    String apellidos,
  ) async {
    try {
      final data = await ApiService.buscarEmpleados({
        "identificacion": identificacion,
        "apellidos": apellidos,
        "area": areaSeleccionada ?? '',
        "cargo": cargoSeleccionado ?? '',
      });

      resultados = List<Map<String, dynamic>>.from(data);
      notifyListeners();
    } catch (e) {
      debugPrint('Error al buscar empleados: \$e');
    }
  }

  void setArea(String? value) {
    areaSeleccionada = value;
    notifyListeners();
  }

  void setCargo(String? value) {
    cargoSeleccionado = value;
    notifyListeners();
  }

  void limpiarFiltros() {
    areaSeleccionada = null;
    cargoSeleccionado = null;
    resultados = [];
    notifyListeners();
  }
}
