import 'package:flutter/material.dart';
import 'api_service.dart';

class RegistroEmpleadoScreen extends StatefulWidget {
  const RegistroEmpleadoScreen({super.key});

  @override
  State<RegistroEmpleadoScreen> createState() => _RegistroEmpleadoScreenState();
}

class _RegistroEmpleadoScreenState extends State<RegistroEmpleadoScreen> {
  List<Map<String, dynamic>> areas = [];
  List<Map<String, dynamic>> cargos = [];
  List<Map<String, dynamic>> bancos = [];
  List<Map<String, dynamic>> epsList = [];
  List<Map<String, dynamic>> pensiones = [];
  List<Map<String, dynamic>> contratos = [];

  final _formKey = GlobalKey<FormState>();

  final TextEditingController identificacionController = TextEditingController();
  final TextEditingController nombresController = TextEditingController();
  final TextEditingController apellidosController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
  final TextEditingController fechaNacimientoController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController salarioController = TextEditingController();
  final TextEditingController cuentaController = TextEditingController();

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
    _inicializarCombos();
  }

  Future<void> _inicializarCombos() async {
    try {
      final data = await cargarCombos();
      setState(() {
        areas = data['areas'] ?? [];
        cargos = data['cargos'] ?? [];
        bancos = data['bancos'] ?? [];
        epsList = data['eps'] ?? [];
        pensiones = data['pensiones'] ?? [];
        contratos = data['contratos'] ?? [];
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al cargar los combos')),
      );
    }
  }

  void _mostrarDialogoConfirmacion() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Éxito'),
        content: const Text('Empleado agregado correctamente.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _limpiarFormulario();
            },
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
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

  @override
  Widget build(BuildContext context) {
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
                    const Text(
                      "Formulario de Registro",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),

                    TextFormField(
                      controller: identificacionController,
                      decoration: const InputDecoration(labelText: 'Identificación'),
                      validator: (value) => value == null || value.isEmpty ? 'Campo obligatorio' : null,
                    ),
                    const SizedBox(height: 10),

                    TextFormField(
                      controller: nombresController,
                      decoration: const InputDecoration(labelText: 'Nombres'),
                      validator: (value) => value == null || value.isEmpty ? 'Campo obligatorio' : null,
                    ),
                    const SizedBox(height: 10),

                    TextFormField(
                      controller: apellidosController,
                      decoration: const InputDecoration(labelText: 'Apellidos'),
                      validator: (value) => value == null || value.isEmpty ? 'Campo obligatorio' : null,
                    ),
                    const SizedBox(height: 10),

                    TextFormField(
                      controller: telefonoController,
                      decoration: const InputDecoration(labelText: 'Teléfono'),
                      validator: (value) => value == null || value.isEmpty ? 'Campo obligatorio' : null,
                    ),
                    const SizedBox(height: 10),

                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(labelText: 'Correo electrónico'),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Campo obligatorio';
                        final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                        return emailRegex.hasMatch(value) ? null : 'Correo inválido';
                      },
                    ),
                    const SizedBox(height: 10),

                    TextFormField(
                      controller: salarioController,
                      decoration: const InputDecoration(labelText: 'Salario'),
                      keyboardType: TextInputType.number,
                      validator: (value) => value == null || value.isEmpty ? 'Campo obligatorio' : null,
                    ),
                    const SizedBox(height: 10),

                    TextFormField(
                      controller: cuentaController,
                      decoration: const InputDecoration(labelText: 'Cuenta bancaria'),
                      validator: (value) => value == null || value.isEmpty ? 'Campo obligatorio' : null,
                    ),
                    const SizedBox(height: 10),

                    TextFormField(
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
                            fechaNacimientoController.text =
                                '${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}/${picked.year.toString()}';
                            fechaFormateadaParaBackend =
                                '${picked.year.toString()}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
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
                    const SizedBox(height: 20),

                    DropdownButtonFormField<int>(
                      value: idAreaSeleccionada,
                      items: areas.map((item) => DropdownMenuItem<int>(
                        value: item['id'],
                        child: Text(item['nombre']),
                      )).toList(),
                      onChanged: (value) => setState(() => idAreaSeleccionada = value),
                      decoration: const InputDecoration(labelText: 'Área'),
                    ),
                    const SizedBox(height: 10),

                    DropdownButtonFormField<int>(
                      value: idCargoSeleccionado,
                      items: cargos.map((item) => DropdownMenuItem<int>(
                        value: item['id'],
                        child: Text(item['nombre']),
                      )).toList(),
                      onChanged: (value) => setState(() => idCargoSeleccionado = value),
                      decoration: const InputDecoration(labelText: 'Cargo'),
                    ),
                    const SizedBox(height: 10),

                    DropdownButtonFormField<int>(
                      value: idBancoSeleccionado,
                      items: bancos.map((item) => DropdownMenuItem<int>(
                        value: item['id'],
                        child: Text(item['nombre']),
                      )).toList(),
                      onChanged: (value) => setState(() => idBancoSeleccionado = value),
                      decoration: const InputDecoration(labelText: 'Banco'),
                    ),
                    const SizedBox(height: 10),

                    DropdownButtonFormField<int>(
                      value: idEpsSeleccionada,
                      items: epsList.map((item) => DropdownMenuItem<int>(
                        value: item['id'],
                        child: Text(item['nombre']),
                      )).toList(),
                      onChanged: (value) => setState(() => idEpsSeleccionada = value),
                      decoration: const InputDecoration(labelText: 'EPS'),
                    ),
                    const SizedBox(height: 10),

                    DropdownButtonFormField<int>(
                      value: idPensionSeleccionada,
                      items: pensiones.map((item) => DropdownMenuItem<int>(
                        value: item['id'],
                        child: Text(item['nombre']),
                      )).toList(),
                      onChanged: (value) => setState(() => idPensionSeleccionada = value),
                      decoration: const InputDecoration(labelText: 'Fondo de Pensión'),
                    ),
                    const SizedBox(height: 10),

                    DropdownButtonFormField<int>(
                      value: idContratoSeleccionado,
                      items: contratos.map((item) => DropdownMenuItem<int>(
                        value: item['id'],
                        child: Text(item['nombre']),
                      )).toList(),
                      onChanged: (value) => setState(() => idContratoSeleccionado = value),
                      decoration: const InputDecoration(labelText: 'Tipo de Contrato'),
                    ),
                    const SizedBox(height: 30),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await registrarEmpleado(
                                identificacion: identificacionController.text,
                                nombres: nombresController.text,
                                apellidos: apellidosController.text,
                                telefono: telefonoController.text,
                                correo: emailController.text,
                                salario: salarioController.text,
                                cuenta: cuentaController.text,
                                fechaNac: fechaFormateadaParaBackend,
                                idArea: idAreaSeleccionada,
                                idCargo: idCargoSeleccionado,
                                idBanco: idBancoSeleccionado,
                                idEps: idEpsSeleccionada,
                                idPension: idPensionSeleccionada,
                                idContrato: idContratoSeleccionado,
                              );
                              _mostrarDialogoConfirmacion();
                            }
                          },
                          icon: const Icon(Icons.save),
                          label: const Text('Registrar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3B5998),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                        ),
                        const SizedBox(width: 20),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.cancel),
                          label: const Text('Cancelar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
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
}
