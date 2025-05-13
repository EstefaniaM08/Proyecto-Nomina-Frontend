import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/generacion_nomina_viewmodel.dart';

class GeneracionNominaEmpleadoScreen extends StatefulWidget {
  const GeneracionNominaEmpleadoScreen({super.key});

  @override
  State<GeneracionNominaEmpleadoScreen> createState() =>
      _GeneracionNominaEmpleadoScreenState();
}

class _GeneracionNominaEmpleadoScreenState
    extends State<GeneracionNominaEmpleadoScreen> {
  final TextEditingController identificacionController =
      TextEditingController();
  final TextEditingController fechaController = TextEditingController();
  final TextEditingController comisionesController = TextEditingController();
  final TextEditingController viaticosController = TextEditingController();
  final TextEditingController representacionController =
      TextEditingController();
  final TextEditingController extDiurnasController = TextEditingController();
  final TextEditingController extNocturnasController = TextEditingController();
  final TextEditingController extDomDiurController = TextEditingController();
  final TextEditingController extDomNocController = TextEditingController();

  Map<String, dynamic>? resultadoNomina;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<GeneracionNominaViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Generar Nómina Empleado")),
      backgroundColor: const Color(0xEDF3FAFF),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Datos Empleado",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      identificacionController,
                      'Identificación',
                      TextInputType.number,
                    ),
                    TextFormField(
                      controller: fechaController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'Fecha',
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          fechaController.text =
                              '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
                        }
                      },
                      validator:
                          (value) =>
                              value!.isEmpty ? 'Campo obligatorio' : null,
                    ),

                    const SizedBox(height: 24),
                    const Text(
                      "Valores Posible a Pagar",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      comisionesController,
                      'Comisiones',
                      TextInputType.number,
                    ),
                    _buildTextField(
                      viaticosController,
                      'Viáticos',
                      TextInputType.number,
                    ),
                    _buildTextField(
                      representacionController,
                      'Gastos Representación',
                      TextInputType.number,
                    ),
                    _buildTextField(
                      extDiurnasController,
                      'Hor Ext Diurnas',
                      TextInputType.number,
                    ),
                    _buildTextField(
                      extNocturnasController,
                      'Hor Ext Nocturnas',
                      TextInputType.number,
                    ),
                    _buildTextField(
                      extDomDiurController,
                      'Hor Ext Diu Dominical o Festivos',
                      TextInputType.number,
                    ),
                    _buildTextField(
                      extDomNocController,
                      'Hor Ext Noc Dominical o Festivos',
                      TextInputType.number,
                    ),

                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final datos = {
                                "identificacion":
                                    identificacionController.text.trim(),
                                "fechaPago": fechaController.text.trim(),
                                "comisiones":
                                    int.tryParse(comisionesController.text) ??
                                    0,
                                "viaticos":
                                    int.tryParse(viaticosController.text) ?? 0,
                                "gastosRepresentacion":
                                    int.tryParse(
                                      representacionController.text,
                                    ) ??
                                    0,
                                "horExtraDiu":
                                    int.tryParse(extDiurnasController.text) ??
                                    0,
                                "horExtraNoc":
                                    int.tryParse(extNocturnasController.text) ??
                                    0,
                                "horExtraDiuDomFes":
                                    int.tryParse(extDomDiurController.text) ??
                                    0,
                                "horExtraNocDomFes":
                                    int.tryParse(extDomNocController.text) ?? 0,
                              };
                              final response = await vm.generarNomina(
                                identificacion: identificacionController.text,
                                fechaPago: fechaController.text,
                                comisiones: comisionesController.text,
                                viaticos: viaticosController.text,
                                representacion: representacionController.text,
                                extDiu: extDiurnasController.text,
                                extNoc: extNocturnasController.text,
                                extDomDiu: extDomDiurController.text,
                                extDomNoc: extDomNocController.text,
                              );
                              setState(() => resultadoNomina = response);
                            }
                          },
                          icon: const Icon(Icons.check),
                          label: const Text('Generar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.cancel),
                          label: const Text('Cancelar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    if (resultadoNomina != null)
                      _buildResultados(resultadoNomina!),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    TextInputType type,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        decoration: InputDecoration(labelText: label),
        validator:
            (value) =>
                value == null || value.isEmpty ? 'Campo obligatorio' : null,
      ),
    );
  }

  Widget _buildResultados(Map<String, dynamic> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        _buildResultadoCard(
          title: 'Devengados',
          items: {
            'Salario': data['salario'],
            'Subsidio de Transporte': data['subsidioTransporte'],
            'Prima': data['prima'],
            'Cesantías': data['cesantias'],
            'Vacaciones': data['vacaciones'],
            'Valor Horas Extras': data['totValHorExtra'],
          },
        ),
        _buildResultadoCard(
          title: 'Descuentos',
          items: {
            'Salud': data['salud'],
            'Pensión': data['pension'],
            'Retención Fuente': data['retencionFuente'],
            'Fondo Solidario': data['fondoSolid'],
          },
        ),
        _buildResultadoCard(
          title: 'Totales',
          items: {
            'Total Devengados': data['totDevengados'],
            'Total Descuentos': data['totDescuetos'],
            'Pago Final': data['pagoFinal'],
          },
        ),
      ],
    );
  }

  Widget _buildResultadoCard({
    required String title,
    required Map<String, dynamic> items,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(thickness: 1),
            ...items.entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        entry.key,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Text(
                      '${entry.value ?? ''}',
                      style: const TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
