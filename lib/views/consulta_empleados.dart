import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/consulta_empleados_viewmodel.dart';

class ConsultaEmpleadosScreen extends StatefulWidget {
  const ConsultaEmpleadosScreen({super.key});

  @override
  State<ConsultaEmpleadosScreen> createState() => _ConsultaEmpleadosScreenState();
}

class _ConsultaEmpleadosScreenState extends State<ConsultaEmpleadosScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<ConsultaEmpleadosViewModel>(context, listen: false).cargarCombos();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ConsultaEmpleadosViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Consulta de Empleados')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _campoTexto('Identificación', vm.identificacionController),
            _campoTexto('Apellidos', vm.apellidosController),
            _combo('Área', vm.areas, vm.areaSeleccionada, (val) => vm.areaSeleccionada = val),
            _combo('Cargo', vm.cargos, vm.cargoSeleccionado, (val) => vm.cargoSeleccionado = val),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: vm.cargando ? null : () => vm.buscarEmpleados(),
              child: vm.cargando
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Buscar'),
            ),
            const SizedBox(height: 10),
            Text(
              vm.mensaje,
              style: const TextStyle(color: Colors.blue),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: vm.resultados.length,
                itemBuilder: (context, index) {
                  final empleado = vm.resultados[index];
                  return ListTile(
                    title: Text('${empleado['nombres']} ${empleado['apellidos']}'),
                    subtitle: Text('Área: ${empleado['area']} | Cargo: ${empleado['cargo']}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Funciones de soporte para campo de texto y combo
  Widget _campoTexto(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      ),
    );
  }

  Widget _combo(String label, List<String> items, String? selectedValue, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
        value: selectedValue,
        items: items.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
