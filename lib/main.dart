import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'viewmodels/login_viewmodel.dart';
import 'viewmodels/registro_empleado_viewmodel.dart';
import 'viewmodels/consulta_empleados_viewmodel.dart';
import 'viewmodels/generacion_nomina_viewmodel.dart'; // ✅ nuevo

import 'views/login.dart';
import 'views/registro_empleado.dart';
import 'views/consulta_empleados.dart';
import 'views/menu_principal.dart';
import 'views/generacion_nomina_empleado.dart'; // ✅ nuevo

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => RegistroEmpleadoViewModel()),
        ChangeNotifierProvider(create: (_) => ConsultaEmpleadosViewModel()),
        ChangeNotifierProvider(create: (_) => GeneracionNominaViewModel()), // ✅ nuevo
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistema de Nómina',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (_) => const LoginScreen(),
        '/registro': (_) => const RegistroEmpleadoScreen(),
        '/consulta': (_) => const ConsultaEmpleadosScreen(),
        '/menu': (_) => const MenuPrincipalScreen(
              email: 'usuario@email.com',
            ),
        '/generar-nomina-empleado': (_) =>
            const GeneracionNominaEmpleadoScreen(), // ✅ nueva ruta
      },
    );
  }
}
