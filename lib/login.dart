// login.dart
import 'package:flutter/material.dart';
import 'usuario.dart';
import 'api_service.dart';
import 'menu_principal.dart';
import 'registro_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String mensaje = '';
  bool cargando = false;

  void _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      cargando = true;
      mensaje = '';
    });

    final usuario = Usuario(
      email: emailController.text.trim(),
      password: passwordController.text,
    );

    try {
      final loginExitoso = await loginUsuario(usuario);

      if (loginExitoso) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MenuPrincipal(email: usuario.email),
          ),
        );
      } else {
        setState(() {
          mensaje = "❌ Credenciales incorrectas";
        });
      }
    } catch (e) {
      setState(() {
        mensaje = "❌ Error: ${e.toString()}";
      });
    } finally {
      setState(() {
        cargando = false;
      });
    }
  }

  String? _validarEmail(String? value) {
    if (value == null || value.isEmpty) return "El correo es obligatorio";
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) return "Ingrese un correo válido";
    return null;
  }

  String? _validarPassword(String? value) {
    if (value == null || value.isEmpty) return "La contraseña es obligatoria";
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Form(
            key: _formKey,
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
                TextFormField(
                  controller: emailController,
                  validator: _validarEmail,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: "Email",
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: passwordController,
                  validator: _validarPassword,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: "Contraseña",
                    prefixIcon: Icon(Icons.lock),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: cargando ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B5998),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: cargando
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Ingresar", style: TextStyle(fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 16),
                Text(mensaje, style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 16),
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
