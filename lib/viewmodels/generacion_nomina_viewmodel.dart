import 'package:flutter/material.dart';
import '../services/api_service.dart';

class GeneracionNominaViewModel extends ChangeNotifier {
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
}
