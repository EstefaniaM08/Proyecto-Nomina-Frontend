import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ConsultaNominasViewModel extends ChangeNotifier {
  List<Map<String, dynamic>> resultados = [];

  Future<void> buscarNominas({
    required String identificacion,
    required String fecha,
    required String totDesDesde,
    required String totDesHasta,
  }) async {
    try {
      final filtros = <String, dynamic>{};

      if (identificacion.isNotEmpty) filtros['identificacion'] = identificacion;
      if (fecha.isNotEmpty) filtros['fecha'] = fecha;
      if (totDesDesde.isNotEmpty) filtros['totDesDesde'] = totDesDesde;
      if (totDesHasta.isNotEmpty) filtros['totDesHasta'] = totDesHasta;

      resultados = await ApiService.buscarNominas(filtros);
      notifyListeners();
    } catch (e) {
      print("❌ Error al buscar nóminas: $e");
    }
  }

  void limpiarFiltros() {
    resultados = [];
    notifyListeners();
  }

  Future<void> descargarPDFNomina(
    Map<String, dynamic> nomina,
    BuildContext context,
  ) async {
    try {
      await ApiService.descargarYMostrarPDF(nomina, context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al descargar PDF: $e')));
    }
  }

  Future<void> exportarExcel({
    required String identificacion,
    required String fecha,
    required String totDesDesde,
    required String totDesHasta,
    required String totDevDesde,
    required String totDevHasta,
    required String pagFinDesde,
    required String pagFinHasta,
    required BuildContext context,
  }) async {
    final filtros = <String, dynamic>{};

    if (identificacion.isNotEmpty) filtros['identificacion'] = identificacion;
    if (fecha.isNotEmpty) filtros['fecha'] = fecha;
    if (totDesDesde.isNotEmpty) filtros['totDesDesde'] = totDesDesde;
    if (totDesHasta.isNotEmpty) filtros['totDesHasta'] = totDesHasta;
    if (totDevDesde.isNotEmpty) filtros['totDevDesde'] = totDevDesde;
    if (totDevHasta.isNotEmpty) filtros['totDevHasta'] = totDevHasta;
    if (pagFinDesde.isNotEmpty) filtros['pagFinDesde'] = pagFinDesde;
    if (pagFinHasta.isNotEmpty) filtros['pagFinHasta'] = pagFinHasta;

    try {
      await ApiService.exportarExcelNominas(filtros);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Excel exportado exitosamente')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('❌ Error al exportar Excel: $e')));
    }
  }
}
