import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/registro_viewmodel.dart';

class RegistroScreen extends StatelessWidget {
  const RegistroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RegistroViewModel(),
      child: Scaffold(
        appBar: AppBar(title: const Text("Registro de Administrador")),
        body: Consumer<RegistroViewModel>(
          builder: (context, vm, _) {
            final formKey = GlobalKey<FormState>();

            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      const Text("Registrar un Administrador",
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 30),

                      // Email
                      TextFormField(
                        controller: vm.emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          hintText: "Email",
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) return "Campo obligatorio";
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return "Correo inválido";
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Contraseña
                      TextFormField(
                        controller: vm.pass1Controller,
                        obscureText: !vm.mostrarPass1,
                        decoration: InputDecoration(
                          hintText: "Contraseña",
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(vm.mostrarPass1 ? Icons.visibility : Icons.visibility_off),
                            onPressed: vm.toggleMostrarPass1,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) return "Campo obligatorio";
                          if (value.length < 8) return "Mínimo 8 caracteres";
                          if (!RegExp(r'[A-Z]').hasMatch(value)) return "Debe tener al menos una mayúscula";
                          if (!RegExp(r'[a-z]').hasMatch(value)) return "Debe tener al menos una minúscula";
                          if (!RegExp(r'[0-9]').hasMatch(value)) return "Debe tener al menos un número";
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Confirmar contraseña
                      TextFormField(
                        controller: vm.pass2Controller,
                        obscureText: !vm.mostrarPass2,
                        decoration: InputDecoration(
                          hintText: "Confirmar contraseña",
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(vm.mostrarPass2 ? Icons.visibility : Icons.visibility_off),
                            onPressed: vm.toggleMostrarPass2,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) return "Campo obligatorio";
                          if (value != vm.pass1Controller.text) return "Las contraseñas no coinciden";
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Botón registrar
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3B5998),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          onPressed: vm.cargando
                              ? null
                              : () async {
                                  if (!formKey.currentState!.validate()) return;

                                  final registrado = await vm.registrarUsuario(context);
                                  if (registrado) Navigator.pop(context);
                                },
                          child: vm.cargando
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text("Registrarse"),
                        ),
                      ),

                      const SizedBox(height: 16),
                      Text(vm.mensaje, style: const TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
