import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../viewmodels/consulta_nominas_viewmodel.dart';

class ConsultaNominasScreen extends StatefulWidget {
  const ConsultaNominasScreen({super.key});

  @override
  State<ConsultaNominasScreen> createState() => _ConsultaNominasScreenState();
}

class _ConsultaNominasScreenState extends State<ConsultaNominasScreen> {
  final TextEditingController identificacionController =
      TextEditingController();
  final TextEditingController fechaController = TextEditingController();
  final TextEditingController totDesDesdeController = TextEditingController();
  final TextEditingController totDesHastaController = TextEditingController();

  @override
  void dispose() {
    identificacionController.dispose();
    fechaController.dispose();
    totDesDesdeController.dispose();
    totDesHastaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ConsultaNominasViewModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFEAF6FF),
      appBar: AppBar(title: const Text("Consulta de Nóminas")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 6,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Filtros de búsqueda",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: identificacionController,
                    decoration: const InputDecoration(
                      labelText: 'Identificación',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: fechaController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Fecha',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    onTap: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          fechaController.text =
                              "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: totDesDesdeController,
                    decoration: const InputDecoration(
                      labelText: 'Total Descuentos Desde',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: totDesHastaController,
                    decoration: const InputDecoration(
                      labelText: 'Total Descuentos Hasta',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              identificacionController.clear();
                              fechaController.clear();
                              totDesDesdeController.clear();
                              totDesHastaController.clear();
                              vm.limpiarFiltros();
                            },
                            icon: const Icon(Icons.clear, color: Colors.white),
                            label: const Text(
                              "Limpiar",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              minimumSize: const Size(130, 40),
                            ),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton.icon(
                            onPressed: () {
                              vm.buscarNominas(
                                identificacion:
                                    identificacionController.text.trim(),
                                fecha: fechaController.text.trim(),
                                totDesDesde: totDesDesdeController.text.trim(),
                                totDesHasta: totDesHastaController.text.trim(),
                              );
                            },
                            icon: const Icon(Icons.search, color: Colors.white),
                            label: const Text(
                              "Buscar",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              minimumSize: const Size(130, 40),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            vm.exportarExcel(
                              identificacion:
                                  identificacionController.text.trim(),
                              fecha: fechaController.text.trim(),
                              totDesDesde: totDesDesdeController.text.trim(),
                              totDesHasta: totDesHastaController.text.trim(),
                              totDevDesde: '',
                              totDevHasta: '',
                              pagFinDesde: '',
                              pagFinHasta: '',
                              context: context,
                            );
                          },
                          icon: const Icon(Icons.download, color: Colors.white),
                          label: const Text(
                            "Exportar Excel",
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            minimumSize: const Size(200, 45),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  if (vm.resultados.isNotEmpty)
                    const Text(
                      "Resultados",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  const SizedBox(height: 8),
                  if (vm.resultados.isNotEmpty)
                    Expanded(
                      child: ListView.builder(
                        itemCount: vm.resultados.length,
                        itemBuilder: (context, index) {
                          final nomina = vm.resultados[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              title: Text(
                                "Nombre: ${nomina['personal']?['nombres'] ?? ''} ${nomina['personal']?['apellidos'] ?? ''}",
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "ID: ${nomina['personal']?['identificacion'] ?? ''}",
                                  ),
                                  Text("Fecha: ${nomina['fechaPago'] ?? ''}"),
                                  Text(
                                    "Salario: \$${nomina['personal']?['salario'] ?? 0}",
                                  ),
                                  Text(
                                    "Total Devengados: \$${nomina['totDevengados']}",
                                  ),
                                  Text(
                                    "Total Descuentos: \$${nomina['totDescuetos']}",
                                  ),
                                  Text("Pago Final: \$${nomina['pagoFinal']}"),
                                  const SizedBox(height: 8),

                                  TextButton.icon(
                                    onPressed: () {
                                      final payload = {
                                        "cedula":
                                            nomina['personal']?['identificacion'],
                                        "fecha": nomina['fechaPago'],
                                        "nombre":
                                            "${nomina['personal']?['nombres']} ${nomina['personal']?['apellidos']}",

                                        "cargo":
                                            nomina['personal']?['cargo']?['nombre'],
                                        "cuenta":
                                            nomina['personal']?['cuentaBancaria'],
                                        "banco":
                                            nomina['personal']?['banco']?['nombre'],
                                        "salario":
                                            nomina['personal']?['salario'],
                                        "totDev": nomina['totDevengados'],
                                        "totDes": nomina['totDescuetos'],
                                        "totalPagar": nomina['pagoFinal'],
                                      };

                                      vm.descargarPDFNomina(payload, context);
                                    },
                                    icon: const Icon(
                                      Icons.picture_as_pdf,
                                      color: Colors.blue,
                                    ),
                                    label: const Text(
                                      "Desprendible",
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ),
                                ],
                              ),
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
