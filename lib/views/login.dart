import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/login_viewmodel.dart';
import 'menu_principal.dart';
import 'registro_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<LoginViewModel>(context);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Form(
            key: vm.formKey,
            child: Column(
              children: [
                const Text(
                  "Iniciar Sesión",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3B5998),
                  ),
                ),
                const SizedBox(height: 30),

                // Email
                TextFormField(
                  controller: vm.emailController,
                  validator: vm.validarEmail,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: "Email",
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                const SizedBox(height: 20),

                // Contraseña
                TextFormField(
                  controller: vm.passwordController,
                  validator: vm.validarPassword,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: "Contraseña",
                    prefixIcon: Icon(Icons.lock),
                  ),
                ),
                const SizedBox(height: 24),

                // Botón Ingresar
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: vm.cargando
                        ? null
                        : () async {
                            final loginCorrecto = await vm.login();
                            if (loginCorrecto && context.mounted) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => MenuPrincipalScreen(email: vm.emailController.text),
                                ),
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B5998),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: vm.cargando
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Ingresar", style: TextStyle(fontSize: 16)),
                  ),
                ),

                const SizedBox(height: 16),
                Text(vm.mensaje, style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 16),

                // Registro
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RegistroScreen()),
                    );
                  },
                  child: const Text("¿No tienes cuenta? Regístrate aquí"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
