import 'package:flutter/material.dart';
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
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
              },
            )
          ],
        ),
      ),
      body: const Center(
        child: Text(
          "Selecciona una opción en el menú",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, IconData icon, String text) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: () {
        Navigator.pop(context); // Cierra el drawer
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Acción seleccionada: $text")),
        );
      },
    );
  }
}
