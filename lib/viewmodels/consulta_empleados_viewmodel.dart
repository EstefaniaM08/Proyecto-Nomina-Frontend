// lib/viewmodels/consulta_empleados_viewmodel.dart
import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ConsultaEmpleadosViewModel extends ChangeNotifier {
  final TextEditingController identificacionController = TextEditingController();
  final TextEditingController apellidosController = TextEditingController();

  List<Map<String, dynamic>> resultados = [];
  List<String> areas = [];
  List<String> cargos = [];

  String mensaje = '';
  bool cargando = false;

  String? _areaSeleccionada;
  String? _cargoSeleccionado;

  String? get areaSeleccionada => _areaSeleccionada;
  String? get cargoSeleccionado => _cargoSeleccionado;

  set areaSeleccionada(String? value) {
    _areaSeleccionada = value;
    notifyListeners();
  }

  set cargoSeleccionado(String? value) {
    _cargoSeleccionado = value;
    notifyListeners();
  }

  Future<void> cargarCombos() async {
    try {
      final areasData = await ApiService.obtenerLista('areas');
      final cargosData = await ApiService.obtenerLista('cargos');
      areas = areasData.map((e) => e['nombre'].toString()).toList();
      cargos = cargosData.map((e) => e['nombre'].toString()).toList();
      notifyListeners();
    } catch (e) {
      mensaje = 'Error al cargar combos';
      notifyListeners();
    }
  }

  Future<void> buscarEmpleados() async {
    cargando = true;
    notifyListeners();

    final filtros = {
      'identificacion': identificacionController.text,
      'apellidos': apellidosController.text,
      'area': _areaSeleccionada ?? '',
      'cargo': _cargoSeleccionado ?? '',
    };

    try {
      final data = await ApiService.buscarEmpleados(filtros);
      resultados = List<Map<String, dynamic>>.from(data);
      mensaje = 'Se encontraron ${resultados.length} resultados';
    } catch (e) {
      mensaje = 'Error al buscar empleados';
    } finally {
      cargando = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    identificacionController.dispose();
    apellidosController.dispose();
    super.dispose();
  }
}
