import 'package:flutter/material.dart';
import 'login.dart';
import 'registro_empleado.dart';
import 'consulta_empleados.dart';
import 'generacion_nomina_empleado.dart';
import 'modificar_empleado.dart';

class MenuPrincipalScreen extends StatelessWidget {
  final String email;

  const MenuPrincipalScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Menú Principal")),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: const Text("Bienvenido"),
              accountEmail: Text(email),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40, color: Colors.blue),
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF3B5998), Color(0xFF192f6a)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),

            // Sección: Personal
            ExpansionTile(
              leading: const Icon(Icons.people),
              title: const Text("Personal"),
              children: [
                ListTile(
                  leading: const Icon(Icons.person_add),
                  title: const Text("Registrar Empleado"),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const RegistroEmpleadoScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.people_outline),
                  title: const Text("Consultar Empleados"),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ConsultaEmpleadosScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: const Text("Modificar Empleado"),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/modificar-empleado');
                  },
                ),
              ],
            ),

            // Sección: Pagos
            ExpansionTile(
              leading: const Icon(Icons.attach_money),
              title: const Text("Pagos"),
              children: [
                ListTile(
                  leading: const Icon(Icons.playlist_add),
                  title: const Text("Generar Nómina"),
                  onTap: () {
                    Navigator.pop(context); // Cierra el Drawer
                    Navigator.pushNamed(context, '/generar-nomina');
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.person_add_alt_1),
                  title: const Text("Generar Nómina Empleado"),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/generar-nomina-empleado');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.receipt_long),
                  title: const Text("Consultar Nóminas"),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/consulta-nominas');
                  },
                ),
              ],
            ),

            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                "Cerrar sesión",
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: const Text("Cerrar sesión"),
                        content: const Text(
                          "¿Estás seguro de que deseas cerrar sesión?",
                        ),
                        actions: [
                          TextButton(
                            child: const Text("Cancelar"),
                            onPressed: () => Navigator.pop(context),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            child: const Text("Cerrar sesión"),
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const LoginScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            color: Colors.blue.shade50,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.dashboard_customize,
                      size: 50,
                      color: Colors.blue.shade700,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "¡Bienvenido de nuevo!",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    email,
                    style: const TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Selecciona una opción del menú lateral para comenzar.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.black54),
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
