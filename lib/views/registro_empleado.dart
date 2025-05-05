import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/registro_empleado_viewmodel.dart';

class RegistroEmpleadoScreen extends StatefulWidget {
  const RegistroEmpleadoScreen({super.key});

  @override
  State<RegistroEmpleadoScreen> createState() => _RegistroEmpleadoScreenState();
}

class _RegistroEmpleadoScreenState extends State<RegistroEmpleadoScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController identificacionController = TextEditingController();
  final TextEditingController nombresController = TextEditingController();
  final TextEditingController apellidosController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController salarioController = TextEditingController();
  final TextEditingController cuentaController = TextEditingController();
  final TextEditingController fechaNacimientoController = TextEditingController();

  int? idAreaSeleccionada;
  int? idCargoSeleccionado;
  int? idBancoSeleccionado;
  int? idEpsSeleccionada;
  int? idPensionSeleccionada;
  int? idContratoSeleccionado;

  DateTime? fechaSeleccionada;
  String fechaFormateadaParaBackend = '';

  @override
  void initState() {
    super.initState();
    Provider.of<RegistroEmpleadoViewModel>(context, listen: false).cargarCombos();
  }

  void _limpiarFormulario() {
    identificacionController.clear();
    nombresController.clear();
    apellidosController.clear();
    telefonoController.clear();
    emailController.clear();
    salarioController.clear();
    cuentaController.clear();
    fechaNacimientoController.clear();
    fechaSeleccionada = null;
    fechaFormateadaParaBackend = '';

    setState(() {
      idAreaSeleccionada = null;
      idCargoSeleccionado = null;
      idBancoSeleccionado = null;
      idEpsSeleccionada = null;
      idPensionSeleccionada = null;
      idContratoSeleccionado = null;
    });
  }

  void _mostrarDialogoConfirmacion() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Éxito'),
        content: const Text('Empleado registrado correctamente.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Aceptar'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<RegistroEmpleadoViewModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFEAF6FF),
      appBar: AppBar(title: const Text("Registrar Empleado")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 6,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Text("Formulario de Registro", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    campoNumerico("Identificación", identificacionController),
                    _campoTexto("Nombres", nombresController),
                    _campoTexto("Apellidos", apellidosController),
                    campoNumerico("Teléfono", telefonoController),
                    _campoCorreo("Correo electrónico", emailController),
                    campoNumerico("Salario", salarioController),
                    _campoTexto("Cuenta bancaria", cuentaController),
                    _campoFecha(),
                    _combo("Área", vm.areas, idAreaSeleccionada, (val) => setState(() => idAreaSeleccionada = val)),
                    _combo("Cargo", vm.cargos, idCargoSeleccionado, (val) => setState(() => idCargoSeleccionado = val)),
                    _combo("Banco", vm.bancos, idBancoSeleccionado, (val) => setState(() => idBancoSeleccionado = val)),
                    _combo("EPS", vm.epsList, idEpsSeleccionada, (val) => setState(() => idEpsSeleccionada = val)),
                    _combo("Fondo de Pensión", vm.pensiones, idPensionSeleccionada, (val) => setState(() => idPensionSeleccionada = val)),
                    _combo("Tipo de Contrato", vm.contratos, idContratoSeleccionado, (val) => setState(() => idContratoSeleccionado = val)),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final exito = await vm.registrarEmpleadoConDatos({
                                "identificacion": identificacionController.text,
                                "nombres": nombresController.text,
                                "apellidos": apellidosController.text,
                                "telefono": telefonoController.text,
                                "correo": emailController.text,
                                "salario": int.parse(salarioController.text),
                                "cuentaBancaria": cuentaController.text,
                                "estado": "Activo",
                                "fechaIngreso": DateTime.now().toIso8601String().split('T').first,
                                "fechaNac": fechaFormateadaParaBackend,
                                "fechaRetiro": null,
                                "cargo": { "id": idCargoSeleccionado },
                                "area": { "id": idAreaSeleccionada },
                                "tipoContrato": { "id": idContratoSeleccionado },
                                "banco": { "id": idBancoSeleccionado },
                                "eps": { "id": idEpsSeleccionada },
                                "pensiones": { "id": idPensionSeleccionada }
                              });

                              if (exito) {
                                _limpiarFormulario();
                                _mostrarDialogoConfirmacion();
                              }
                            }
                          },
                          icon: const Icon(Icons.save, color: Colors.white),
                          label: const Text("Registrar", style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3B5998),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                        ),
                        const SizedBox(width: 20),
                        ElevatedButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.cancel, color: Colors.white),
                          label: const Text("Cancelar", style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _campoTexto(String label, TextEditingController controller, {TextInputType tipo = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
        keyboardType: tipo,
        validator: (value) => value == null || value.isEmpty ? 'Campo obligatorio' : null,
      ),
    );
  }

  Widget _campoCorreo(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
        validator: (value) {
          if (value == null || value.isEmpty) return 'Campo obligatorio';
          if (!value.contains('@')) return 'Debe contener @';
          return null;
        },
      ),
    );
  }

  Widget campoNumerico(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value == null || value.isEmpty) return 'Campo obligatorio';
          if (!RegExp(r'^\d+$').hasMatch(value)) return 'Solo se permiten números';
          return null;
        },
      ),
    );
  }

  Widget _campoFecha() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: fechaNacimientoController,
        readOnly: true,
        onTap: () async {
          final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: fechaSeleccionada ?? DateTime(2000),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          );
          if (picked != null) {
            setState(() {
              fechaSeleccionada = picked;
              fechaNacimientoController.text = '${picked.month}/${picked.day}/${picked.year}';
              fechaFormateadaParaBackend = '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
            });
          }
        },
        decoration: const InputDecoration(
          labelText: 'Fecha de nacimiento',
          hintText: 'MM/DD/YYYY',
          suffixIcon: Icon(Icons.calendar_today),
        ),
        validator: (value) => value == null || value.isEmpty ? 'Campo obligatorio' : null,
      ),
    );
  }

  Widget _combo(String label, List<Map<String, dynamic>> items, int? selected, Function(int?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: DropdownButtonFormField<int>(
        value: selected,
        items: items.map((item) {
          return DropdownMenuItem<int>(
            value: item['id'],
            child: Text(item['nombre']),
          );
        }).toList(),
        onChanged: onChanged,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }
}
