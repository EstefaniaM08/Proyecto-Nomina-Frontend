import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/generar_nomina_viewmodel.dart';

class GenerarNominaScreen extends StatefulWidget {
  const GenerarNominaScreen({super.key});

  @override
  State<GenerarNominaScreen> createState() => _GenerarNominaScreenState();
}

class _GenerarNominaScreenState extends State<GenerarNominaScreen> {
  late GenerarNominaViewModel vm;

  @override
  void initState() {
    super.initState();
    vm = Provider.of<GenerarNominaViewModel>(context, listen: false);
  }

  @override
  void dispose() {
    vm.limpiarArchivo(); // ✅ Se limpia al cerrar la pantalla
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    vm = Provider.of<GenerarNominaViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Generar Nómina desde Excel"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Selecciona un archivo Excel (.xlsx) con los datos de nómina",
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => vm.seleccionarArchivoExcel(context),
                  icon: const Icon(Icons.upload_file),
                  label: const Text("Seleccionar archivo"),
                ),
                const SizedBox(height: 12),
                if (vm.archivoSeleccionado != null)
                  Text(
                    "📄 Archivo: ${vm.archivoSeleccionado!.path.split('/').last}",
                    style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                  ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => vm.enviarArchivoExcel(context),
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text("Generar Nómina"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
