import 'package:flutter/material.dart';
import 'api_service.dart';

class ConsultaEmpleadosScreen extends StatefulWidget {
  const ConsultaEmpleadosScreen({super.key});

  @override
  State<ConsultaEmpleadosScreen> createState() =>
      _ConsultaEmpleadosScreenState();
}

class _ConsultaEmpleadosScreenState extends State<ConsultaEmpleadosScreen> {
  final TextEditingController identificacionController =
      TextEditingController();
  final TextEditingController apellidosController = TextEditingController();

  List<Map<String, dynamic>> resultados = [];
  List<String> areas = [];
  List<String> cargos = [];

  String? areaSeleccionada;
  String? cargoSeleccionado;

  @override
  void initState() {
    super.initState();
    cargarCombosDesdeUi(
      onSuccess:
          (data) => setState(() {
            areas = List<String>.from(
              (data['areas'] ?? []).map((e) => e['nombre'].toString()),
            );
            cargos = List<String>.from(
              (data['cargos'] ?? []).map((e) => e['nombre'].toString()),
            );
          }),
      onError:
          (e) => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al cargar combos: \$e')),
          ),
    );
  }

  void limpiarFiltros() {
    identificacionController.clear();
    apellidosController.clear();
    setState(() {
      areaSeleccionada = null;
      cargoSeleccionado = null;
      resultados = [];
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Filtros limpiados')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Consulta de Empleados")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Filtros de búsqueda",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: TextFormField(
                        controller: identificacionController,
                        decoration: const InputDecoration(
                          labelText: 'Identificación',
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: TextFormField(
                        controller: apellidosController,
                        decoration: const InputDecoration(
                          labelText: 'Apellidos',
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: DropdownButtonFormField<String>(
                        value: areaSeleccionada,
                        items:
                            areas
                                .map(
                                  (area) => DropdownMenuItem(
                                    value: area,
                                    child: Text(area),
                                  ),
                                )
                                .toList(),
                        onChanged:
                            (value) => setState(() => areaSeleccionada = value),
                        decoration: const InputDecoration(labelText: 'Área'),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: DropdownButtonFormField<String>(
                        value: cargoSeleccionado,
                        items:
                            cargos
                                .map(
                                  (cargo) => DropdownMenuItem(
                                    value: cargo,
                                    child: Text(cargo),
                                  ),
                                )
                                .toList(),
                        onChanged:
                            (value) =>
                                setState(() => cargoSeleccionado = value),
                        decoration: const InputDecoration(labelText: 'Cargo'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: limpiarFiltros,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text('Limpiar'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed:
                          () => buscarEmpleadosDesdeUi(
                            identificacionController.text.trim(),
                            apellidosController.text.trim(),
                            areaSeleccionada,
                            cargoSeleccionado,
                            (data) => setState(() {
                              resultados = List<Map<String, dynamic>>.from(
                                data,
                              );
                            }),
                            (error) =>
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error al buscar: \$error'),
                                  ),
                                ),
                          ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      child: const Text('Buscar'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                if (resultados.isNotEmpty)
                  const Text(
                    "Resultados",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                const SizedBox(height: 8),
                if (resultados.isNotEmpty)
                  Expanded(
                    child: ListView.builder(
                      itemCount: resultados.length,
                      itemBuilder: (context, index) {
                        final empleado = resultados[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ExpansionTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${empleado['nombres']} ${empleado['apellidos']}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        (empleado['estado']?.toLowerCase() ==
                                                'activo')
                                            ? Colors.green[100]
                                            : Colors.red[100],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    empleado['estado'] ?? '',
                                    style: TextStyle(
                                      color:
                                          (empleado['estado']?.toLowerCase() ==
                                                  'activo')
                                              ? Colors.green[800]
                                              : Colors.red[800],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            subtitle: Text(
                              "Área: ${empleado['area']?['nombre'] ?? ''} | Cargo: ${empleado['cargo']?['nombre'] ?? ''}",
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Identificación: ${empleado['identificacion'] ?? ''}"),
                                    Text("Correo: ${empleado['correo'] ?? ''}"),
                                    Text(
                                      "Teléfono: ${empleado['telefono'] ?? ''}",
                                    ),
                                    Text(
                                      "Fecha Nac: ${empleado['fechaNac'] ?? ''}",
                                    ),
                                    Text(
                                      "Fecha Ingreso: ${empleado['fechaIngreso'] ?? ''}",
                                    ),
                                    Text("Estado: ${empleado['estado'] ?? ''}"),
                                    Text("Salario: \$${empleado['salario']}"),
                                    Text(
                                      "Banco: ${empleado['banco']?['nombre'] ?? ''}",
                                    ),
                                    Text(
                                      "EPS: ${empleado['eps']?['nombre'] ?? ''}",
                                    ),
                                    Text(
                                      "Pensión: ${empleado['pensiones']?['nombre'] ?? ''}",
                                    ),
                                    Text(
                                      "Tipo Contrato: ${empleado['tipoContrato']?['nombre'] ?? ''}",
                                    ),
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
    );
  }
}
