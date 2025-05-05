import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../viewmodels/consulta_empleados_viewmodel.dart';

class ConsultaEmpleadosScreen extends StatefulWidget {
  const ConsultaEmpleadosScreen({super.key});

  @override
  State<ConsultaEmpleadosScreen> createState() => _ConsultaEmpleadosScreenState();
}

class _ConsultaEmpleadosScreenState extends State<ConsultaEmpleadosScreen> {
  final TextEditingController identificacionController = TextEditingController();
  final TextEditingController apellidosController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final vm = Provider.of<ConsultaEmpleadosViewModel>(context, listen: false);
    vm.cargarCombos();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ConsultaEmpleadosViewModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFEAF6FF),
      appBar: AppBar(title: const Text("Consulta de Empleados")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 6,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Filtros de búsqueda", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: identificacionController,
                    decoration: const InputDecoration(labelText: 'Identificación'),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Campo obligatorio';
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: apellidosController,
                    decoration: const InputDecoration(labelText: 'Apellidos'),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: vm.areaSeleccionada,
                    items: vm.areas
                        .map((area) => DropdownMenuItem(
                              value: area,
                              child: Text(area),
                            ))
                        .toList(),
                    onChanged: (value) => vm.setArea(value),
                    decoration: const InputDecoration(labelText: 'Área'),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: vm.cargoSeleccionado,
                    items: vm.cargos
                        .map((cargo) => DropdownMenuItem(
                              value: cargo,
                              child: Text(cargo),
                            ))
                        .toList(),
                    onChanged: (value) => vm.setCargo(value),
                    decoration: const InputDecoration(labelText: 'Cargo'),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          identificacionController.clear();
                          apellidosController.clear();
                          vm.limpiarFiltros();
                        },
                        icon: const Icon(Icons.clear, color: Colors.white),
                        label: const Text("Limpiar", style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton.icon(
                        onPressed: () {
                          vm.buscarEmpleados(
                            identificacionController.text.trim(),
                            apellidosController.text.trim(),
                          );
                        },
                        icon: const Icon(Icons.search, color: Colors.white),
                        label: const Text("Buscar", style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (vm.resultados.isNotEmpty)
                    const Text("Resultados", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  if (vm.resultados.isNotEmpty)
                    Expanded(
                      child: ListView.builder(
                        itemCount: vm.resultados.length,
                        itemBuilder: (context, index) {
                          final empleado = vm.resultados[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: ExpansionTile(
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${empleado['nombres']} ${empleado['apellidos']}",
                                    style: const TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: (empleado['estado']?.toLowerCase() == 'activo') ? Colors.green[100] : Colors.red[100],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      empleado['estado'] ?? '',
                                      style: TextStyle(
                                        color: (empleado['estado']?.toLowerCase() == 'activo') ? Colors.green[800] : Colors.red[800],
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: Text("Área: ${empleado['area']?['nombre'] ?? ''} | Cargo: ${empleado['cargo']?['nombre'] ?? ''}"),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Identificación: ${empleado['identificacion'] ?? ''}"),
                                      Text("Correo: ${empleado['correo'] ?? ''}"),
                                      Text("Teléfono: ${empleado['telefono'] ?? ''}"),
                                      Text("Fecha Nac: ${empleado['fechaNac'] ?? ''}"),
                                      Text("Fecha Ingreso: ${empleado['fechaIngreso'] ?? ''}"),
                                      Text("Estado: ${empleado['estado'] ?? ''}"),
                                      Text("Salario: \$${empleado['salario']}"),
                                      Text("Banco: ${empleado['banco']?['nombre'] ?? ''}"),
                                      Text("EPS: ${empleado['eps']?['nombre'] ?? ''}"),
                                      Text("Pensión: ${empleado['pensiones']?['nombre'] ?? ''}"),
                                      Text("Tipo Contrato: ${empleado['tipoContrato']?['nombre'] ?? ''}"),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
