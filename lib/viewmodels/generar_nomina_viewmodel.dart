import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_selector/file_selector.dart';
import '../services/api_service.dart';

class GenerarNominaViewModel extends ChangeNotifier {
  File? archivoSeleccionado;

  /// Seleccionar archivo Excel (.xlsx) con file_selector
  Future<void> seleccionarArchivoExcel(BuildContext context) async {
    const XTypeGroup tipoExcel = XTypeGroup(
      label: 'Excel',
      extensions: ['xlsx'],
    );

    final XFile? archivo = await openFile(acceptedTypeGroups: [tipoExcel]);

    if (archivo != null) {
      archivoSeleccionado = File(archivo.path);
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('📄 Archivo seleccionado correctamente')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ Selección de archivo cancelada')),
      );
    }
  }

  /// Enviar el archivo Excel al backend para generar la nómina
  Future<void> enviarArchivoExcel(BuildContext context) async {
    if (archivoSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ Debes seleccionar un archivo primero')),
      );
      return;
    }

    await ApiService.generarNominaDesdeExcel(archivoSeleccionado!, context);
  }

  void limpiarArchivo() {
    archivoSeleccionado = null;
    notifyListeners();
  }
}
