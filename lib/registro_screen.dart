import 'package:flutter/material.dart';
import 'api_service.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final pass1Controller = TextEditingController();
  final pass2Controller = TextEditingController();
  String mensaje = '';
  bool cargando = false;
  bool mostrarPass1 = false;
  bool mostrarPass2 = false;

  void _registrar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      cargando = true;
      mensaje = '';
    });

    try {
      final respuesta = await registrarUsuario(
        emailController.text.trim(),
        pass1Controller.text,
      );

      if (respuesta == "correo_existente") {
        setState(() {
          mensaje = "⚠️ El correo ya está registrado";
        });
      } else if (respuesta == "ok") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Usuario registrado con éxito")),
        );
        Navigator.pop(context); // Volver al login
      }
    } catch (e) {
      setState(() {
        mensaje = "❌ Error al registrar usuario";
      });
    } finally {
      setState(() {
        cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registro de Administrador")),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Text(
                  "Registrar un Administrador",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),

                // Email
                TextFormField(
                  controller: emailController,
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
                  controller: pass1Controller,
                  obscureText: !mostrarPass1,
                  decoration: InputDecoration(
                    hintText: "Contraseña",
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(mostrarPass1 ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          mostrarPass1 = !mostrarPass1;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Campo obligatorio";
                    if (value.length < 8) return "Mínimo 8 caracteres";
                    if (!RegExp(r'[A-Z]').hasMatch(value)) return "Debe contener al menos una mayúscula";
                    if (!RegExp(r'[a-z]').hasMatch(value)) return "Debe contener al menos una minúscula";
                    if (!RegExp(r'[0-9]').hasMatch(value)) return "Debe contener al menos un número";
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Confirmar contraseña
                TextFormField(
                  controller: pass2Controller,
                  obscureText: !mostrarPass2,
                  decoration: InputDecoration(
                    hintText: "Confirmar contraseña",
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(mostrarPass2 ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          mostrarPass2 = !mostrarPass2;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Campo obligatorio";
                    if (value != pass1Controller.text) return "Las contraseñas no coinciden";
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
                    onPressed: cargando ? null : _registrar,
                    child: cargando
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Registrarse"),
                  ),
                ),

                const SizedBox(height: 16),
                Text(mensaje, style: const TextStyle(color: Colors.red)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
