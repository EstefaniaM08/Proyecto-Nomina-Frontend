import 'package:flutter/material.dart';
import 'main.dart';
import 'login.dart';

class MenuPrincipal extends StatelessWidget {
  final String email;

  const MenuPrincipal({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Menú Principal"),
      ),
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
                _buildItem(context, Icons.person_add, "Registrar Empleado"),
                _buildItem(context, Icons.people_outline, "Consultar Empleados"),
                _buildItem(context, Icons.edit_note, "Modificar"),
              ],
            ),

            // Sección: Pagos
            ExpansionTile(
              leading: const Icon(Icons.attach_money),
              title: const Text("Pagos"),
              children: [
                _buildItem(context, Icons.add_card, "Generar Nómina"),
                _buildItem(context, Icons.receipt_long, "Consultar Nóminas"),
              ],
            ),

            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Cerrar sesión", style: TextStyle(color: Colors.red)),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Cerrar sesión"),
                    content: const Text("¿Estás seguro de que deseas cerrar sesión?"),
                    actions: [
                      TextButton(
                        child: const Text("Cancelar"),
                        onPressed: () => Navigator.pop(context),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        child: const Text("Cerrar sesión"),
                        onPressed: () {
                          Navigator.pop(context); // cerrar diálogo
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const LoginScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),

      // CENTRO DE LA PANTALLA
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: Colors.blue.shade50,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.dashboard_customize, size: 50, color: Colors.blue.shade700),
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
                    style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
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

  Widget _buildItem(BuildContext context, IconData icon, String text) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: () {
        Navigator.pop(context); // cerrar drawer
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Acción seleccionada: $text")),
        );
      },
    );
  }
}
