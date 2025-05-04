import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/registro_empleado_viewmodel.dart';

class RegistroEmpleadoScreen extends StatefulWidget {
  const RegistroEmpleadoScreen({super.key});

  @override
  State<RegistroEmpleadoScreen> createState() => _RegistroEmpleadoScreenState();
}

class _RegistroEmpleadoScreenState extends State<RegistroEmpleadoScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<RegistroEmpleadoViewModel>(context, listen: false).cargarCombos();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<RegistroEmpleadoViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Registro de Empleado')),
      body: vm.cargando
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: vm.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _campoTexto('Identificación', vm.identificacionController),
                    _campoTexto('Nombres', vm.nombresController),
                    _campoTexto('Apellidos', vm.apellidosController),
                    _campoTexto('Teléfono', vm.telefonoController),
                    _campoTexto('Fecha de nacimiento', vm.fechaNacimientoController),
                    _campoTexto('Correo electrónico', vm.emailController),
                    _campoTexto('Salario', vm.salarioController),
                    _campoTexto('Número de cuenta', vm.cuentaController),
                    _combo('Área', vm.areas, vm.areaSeleccionada, (val) => vm.areaSeleccionada = val),
                    _combo('Cargo', vm.cargos, vm.cargoSeleccionado, (val) => vm.cargoSeleccionado = val),
                    _combo('Banco', vm.bancos, vm.bancoSeleccionado, (val) => vm.bancoSeleccionado = val),
                    _combo('EPS', vm.epsList, vm.epsSeleccionada, (val) => vm.epsSeleccionada = val),
                    _combo('Fondo de pensión', vm.pensiones, vm.pensionSeleccionada, (val) => vm.pensionSeleccionada = val),
                    _combo('Tipo de contrato', vm.contratos, vm.contratoSeleccionado, (val) => vm.contratoSeleccionado = val),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => vm.registrarEmpleado(),
                      child: const Text('Registrar Empleado'),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      vm.mensaje,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _campoTexto(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
        validator: (value) => value == null || value.isEmpty ? 'Campo requerido' : null,
      ),
    );
  }

  Widget _combo(String label, List<Map<String, dynamic>> items, String? selectedValue, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
        value: selectedValue,
        items: items.map((item) {
          return DropdownMenuItem<String>(
            value: item['nombre'].toString(),
            child: Text(item['nombre']),
          );
        }).toList(),
        onChanged: onChanged,
        validator: (value) => value == null || value.isEmpty ? 'Seleccione una opción' : null,
      ),
    );
  }
}
