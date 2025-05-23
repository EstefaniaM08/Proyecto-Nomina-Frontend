import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'viewmodels/login_viewmodel.dart';
import 'viewmodels/registro_empleado_viewmodel.dart';
import 'viewmodels/consulta_empleados_viewmodel.dart';
import 'viewmodels/generacion_nomina_viewmodel.dart';
import 'viewmodels/modificar_empleado_viewmodel.dart';

import 'views/login.dart';
import 'views/registro_empleado.dart';
import 'views/consulta_empleados.dart';
import 'views/generacion_nomina_empleado.dart';
import 'views/modificar_empleado.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => RegistroEmpleadoViewModel()),
        ChangeNotifierProvider(create: (_) => ConsultaEmpleadosViewModel()),
        ChangeNotifierProvider(create: (_) => GeneracionNominaViewModel()),
        ChangeNotifierProvider(create: (_) => ModificarEmpleadoViewModel()),
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
        '/generar-nomina-empleado': (_) => const GeneracionNominaEmpleadoScreen(),
        '/modificar-empleado': (_) => const ModificarEmpleadoScreen(),
      },
    );
  }
}
