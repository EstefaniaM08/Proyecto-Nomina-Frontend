import 'package:flutter/material.dart';
import '../services/api_service.dart';

class GeneracionNominaViewModel extends ChangeNotifier {
  Map<String, dynamic>? datosEmpleado;

  Future<Map<String, dynamic>> generarNomina({
    required String identificacion,
    required String fechaPago,
    required String comisiones,
    required String viaticos,
    required String representacion,
    required String extDiu,
    required String extNoc,
    required String extDomDiu,
    required String extDomNoc,
  }) async {
    try {
      final datos = {
        "identificacion": identificacion.trim(),
        "fechaPago": fechaPago.trim(),
        "comisiones": int.tryParse(comisiones.trim()) ?? 0,
        "viaticos": int.tryParse(viaticos.trim()) ?? 0,
        "gastosRepresentacion": int.tryParse(representacion.trim()) ?? 0,
        "horExtraDiu": int.tryParse(extDiu.trim()) ?? 0,
        "horExtraNoc": int.tryParse(extNoc.trim()) ?? 0,
        "horExtraDiuDomFes": int.tryParse(extDomDiu.trim()) ?? 0,
        "horExtraNocDomFes": int.tryParse(extDomNoc.trim()) ?? 0,
      };

      final response = await ApiService.pagarNomina(datos);
      return response;
    } catch (e) {
      print('❌ Error generando nómina: $e');
      rethrow;
    }
  }

  Future<void> cargarDatosEmpleado(String identificacion) async {
    try {
      final response = await ApiService.obtenerEmpleadoPorIdentificacion(identificacion);
      datosEmpleado = {
        "nombres": response["nombres"],
        "apellidos": response["apellidos"],
        "cargo": response["cargo"]?["nombre"] ?? '',
        "area": response["area"]?["nombre"] ?? '',
        "tipoContrato": response["tipoContrato"]?["nombre"] ?? '',
        "banco": response["banco"]?["nombre"] ?? '',
        "eps": response["eps"]?["nombre"] ?? '',
        "pensiones": response["pensiones"]?["nombre"] ?? '',
      };
      notifyListeners();
    } catch (e) {
      print('❌ Error cargando datos del empleado: $e');
    }
  }
}
