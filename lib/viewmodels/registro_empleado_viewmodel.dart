import 'package:flutter/material.dart';
import '../services/api_service.dart';

class RegistroEmpleadoViewModel extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController identificacionController = TextEditingController();
  final TextEditingController nombresController = TextEditingController();
  final TextEditingController apellidosController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
  final TextEditingController fechaNacimientoController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController salarioController = TextEditingController();
  final TextEditingController cuentaController = TextEditingController();

  List<Map<String, dynamic>> areas = [];
  List<Map<String, dynamic>> cargos = [];
  List<Map<String, dynamic>> bancos = [];
  List<Map<String, dynamic>> epsList = [];
  List<Map<String, dynamic>> pensiones = [];
  List<Map<String, dynamic>> contratos = [];

  bool cargando = false;
  String mensaje = '';

  // Campos seleccionados con setters y getters
  String? _areaSeleccionada;
  String? _cargoSeleccionado;
  String? _bancoSeleccionado;
  String? _epsSeleccionada;
  String? _pensionSeleccionada;
  String? _contratoSeleccionado;

  String? get areaSeleccionada => _areaSeleccionada;
  set areaSeleccionada(String? value) {
    _areaSeleccionada = value;
    notifyListeners();
  }

  String? get cargoSeleccionado => _cargoSeleccionado;
  set cargoSeleccionado(String? value) {
    _cargoSeleccionado = value;
    notifyListeners();
  }

  String? get bancoSeleccionado => _bancoSeleccionado;
  set bancoSeleccionado(String? value) {
    _bancoSeleccionado = value;
    notifyListeners();
  }

  String? get epsSeleccionada => _epsSeleccionada;
  set epsSeleccionada(String? value) {
    _epsSeleccionada = value;
    notifyListeners();
  }

  String? get pensionSeleccionada => _pensionSeleccionada;
  set pensionSeleccionada(String? value) {
    _pensionSeleccionada = value;
    notifyListeners();
  }

  String? get contratoSeleccionado => _contratoSeleccionado;
  set contratoSeleccionado(String? value) {
    _contratoSeleccionado = value;
    notifyListeners();
  }

  Future<void> cargarCombos() async {
    cargando = true;
    notifyListeners();

    try {
      areas = await ApiService.obtenerLista('areas');
      cargos = await ApiService.obtenerLista('cargos');
      bancos = await ApiService.obtenerLista('bancos');
      epsList = await ApiService.obtenerLista('eps');
      pensiones = await ApiService.obtenerLista('pensiones');
      contratos = await ApiService.obtenerLista('contratos');
    } catch (e) {
      mensaje = 'Error al cargar datos';
    } finally {
      cargando = false;
      notifyListeners();
    }
  }

  Future<void> registrarEmpleado() async {
    if (!formKey.currentState!.validate()) {
      mensaje = 'Por favor complete todos los campos requeridos.';
      notifyListeners();
      return;
    }

    cargando = true;
    notifyListeners();

    final empleado = {
      "identificacion": identificacionController.text,
      "nombres": nombresController.text,
      "apellidos": apellidosController.text,
      "telefono": telefonoController.text,
      "fechaNacimiento": fechaNacimientoController.text,
      "email": emailController.text,
      "salario": salarioController.text,
      "cuenta": cuentaController.text,
      "area": _areaSeleccionada,
      "cargo": _cargoSeleccionado,
      "banco": _bancoSeleccionado,
      "eps": _epsSeleccionada,
      "pension": _pensionSeleccionada,
      "contrato": _contratoSeleccionado,
    };

    try {
      final exito = await ApiService.registrarEmpleado(empleado);
      mensaje = exito ? 'Registro exitoso' : 'Error al registrar empleado';
    } catch (e) {
      mensaje = 'Error inesperado';
    } finally {
      cargando = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    identificacionController.dispose();
    nombresController.dispose();
    apellidosController.dispose();
    telefonoController.dispose();
    fechaNacimientoController.dispose();
    emailController.dispose();
    salarioController.dispose();
    cuentaController.dispose();
    super.dispose();
  }
}
