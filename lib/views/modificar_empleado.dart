import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../viewmodels/modificar_empleado_viewmodel.dart';

class ModificarEmpleadoScreen extends StatefulWidget {
  const ModificarEmpleadoScreen({super.key});

  @override
  State<ModificarEmpleadoScreen> createState() => _ModificarEmpleadoScreenState();
}

class _ModificarEmpleadoScreenState extends State<ModificarEmpleadoScreen> {
  final TextEditingController idController = TextEditingController();

  void limpiarFormulario() {
    idController.clear();
    final vm = Provider.of<ModificarEmpleadoViewModel>(context, listen: false);
    vm.limpiarCampos();
  }

  @override
  void dispose() {
    idController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ModificarEmpleadoViewModel>(context);

    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        if (didPop) {
          limpiarFormulario();
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFEAF6FF),
        appBar: AppBar(
          title: const Text("Modificar Empleado"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              limpiarFormulario();
              Navigator.pop(context);
            },
          ),
        ),
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
                    const Text("Modificar datos de un empleado", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: idController,
                      decoration: const InputDecoration(labelText: 'Identificación'),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (_) => vm.limpiarCampos(),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () async {
                            await vm.buscarEmpleado(idController.text.trim());
                          },
                          icon: const Icon(Icons.search, color: Colors.white),
                          label: const Text("Buscar", style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    if (vm.empleadoData != null)
                      Expanded(
                        child: ListView(
                          children: [
                            const Text("Datos del Empleado", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: vm.nombresController,
                              decoration: const InputDecoration(labelText: 'Nombres'),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: vm.apellidosController,
                              decoration: const InputDecoration(labelText: 'Apellidos'),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: vm.salarioController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              decoration: const InputDecoration(labelText: 'Salario'),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: vm.cuentaController,
                              decoration: const InputDecoration(labelText: 'Cuenta Bancaria'),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: vm.fechaNacController,
                              decoration: const InputDecoration(labelText: 'Fecha de Nacimiento'),
                              onTap: () => vm.seleccionarFechaNac(context),
                              readOnly: true,
                            ),
                            const SizedBox(height: 10),
                            DropdownButtonFormField<int>(
                              value: vm.idArea,
                              items: vm.areas.map((e) => DropdownMenuItem<int>(
                                value: e['id'],
                                child: Text(e['nombre']),
                              )).toList(),
                              onChanged: (val) => vm.setArea(val),
                              decoration: const InputDecoration(labelText: 'Área'),
                            ),
                            const SizedBox(height: 10),
                            DropdownButtonFormField<int>(
                              value: vm.idCargo,
                              items: vm.cargos.map((e) => DropdownMenuItem<int>(
                                value: e['id'],
                                child: Text(e['nombre']),
                              )).toList(),
                              onChanged: (val) => vm.setCargo(val),
                              decoration: const InputDecoration(labelText: 'Cargo'),
                            ),
                            const SizedBox(height: 10),
                            DropdownButtonFormField<int>(
                              value: vm.idContrato,
                              items: vm.contratos.map((e) => DropdownMenuItem<int>(
                                value: e['id'],
                                child: Text(e['nombre']),
                              )).toList(),
                              onChanged: (val) => vm.setContrato(val),
                              decoration: const InputDecoration(labelText: 'Tipo Contrato'),
                            ),
                            const SizedBox(height: 10),
                            DropdownButtonFormField<int>(
                              value: vm.idBanco,
                              items: vm.bancos.map((e) => DropdownMenuItem<int>(
                                value: e['id'],
                                child: Text(e['nombre']),
                              )).toList(),
                              onChanged: (val) => vm.setBanco(val),
                              decoration: const InputDecoration(labelText: 'Banco'),
                            ),
                            const SizedBox(height: 10),
                            DropdownButtonFormField<int>(
                              value: vm.idEps,
                              items: vm.eps.map((e) => DropdownMenuItem<int>(
                                value: e['id'],
                                child: Text(e['nombre']),
                              )).toList(),
                              onChanged: (val) => vm.setEps(val),
                              decoration: const InputDecoration(labelText: 'EPS'),
                            ),
                            const SizedBox(height: 10),
                            DropdownButtonFormField<int>(
                              value: vm.idPension,
                              items: vm.pensiones.map((e) => DropdownMenuItem<int>(
                                value: e['id'],
                                child: Text(e['nombre']),
                              )).toList(),
                              onChanged: (val) => vm.setPension(val),
                              decoration: const InputDecoration(labelText: 'Pensión'),
                            ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () async {
                                    await vm.actualizarEmpleado(context);
                                    showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title: const Text("Éxito"),
                                        content: const Text("La información del empleado se actualizó correctamente."),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              limpiarFormulario();
                                            },
                                            child: const Text("Aceptar"),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.save, color: Colors.white),
                                  label: const Text("Guardar", style: TextStyle(color: Colors.white)),
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () async {
                                    await vm.desactivarEmpleado(context);
                                    limpiarFormulario();
                                  },
                                  icon: const Icon(Icons.block, color: Colors.white),
                                  label: const Text("Desactivar", style: TextStyle(color: Colors.white)),
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
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
