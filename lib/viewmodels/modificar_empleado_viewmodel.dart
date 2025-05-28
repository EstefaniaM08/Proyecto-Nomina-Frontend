import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ModificarEmpleadoViewModel extends ChangeNotifier {
  Map<String, dynamic>? empleadoData;

  final TextEditingController nombresController = TextEditingController();
  final TextEditingController apellidosController = TextEditingController();
  final TextEditingController salarioController = TextEditingController();
  final TextEditingController cuentaController = TextEditingController();
  final TextEditingController fechaNacController = TextEditingController();

  List<Map<String, dynamic>> areas = [];
  List<Map<String, dynamic>> cargos = [];
  List<Map<String, dynamic>> contratos = [];
  List<Map<String, dynamic>> bancos = [];
  List<Map<String, dynamic>> eps = [];
  List<Map<String, dynamic>> pensiones = [];

  int? idArea;
  int? idCargo;
  int? idContrato;
  int? idBanco;
  int? idEps;
  int? idPension;

  ModificarEmpleadoViewModel() {
    cargarCombos();
  }

  Future<void> cargarCombos() async {
    final data = await ApiService.cargarCombos();
    areas = data['areas'] ?? [];
    cargos = data['cargos'] ?? [];
    contratos = data['contratos'] ?? [];
    bancos = data['bancos'] ?? [];
    eps = data['eps'] ?? [];
    pensiones = data['pensiones'] ?? [];
    notifyListeners();
  }

  Future<void> buscarEmpleado(String id) async {
    try {
      final data = await ApiService.obtenerEmpleadoPorIdentificacion(id);
      empleadoData = data;
      nombresController.text = data['nombres'] ?? '';
      apellidosController.text = data['apellidos'] ?? '';
      salarioController.text = data['salario'].toString();
      cuentaController.text = data['cuentaBancaria'] ?? '';
      fechaNacController.text = data['fechaNac'] ?? '';

      idArea = data['area']?['id'];
      idCargo = data['cargo']?['id'];
      idContrato = data['tipoContrato']?['id'];
      idBanco = data['banco']?['id'];
      idEps = data['eps']?['id'];
      idPension = data['pensiones']?['id'];
      notifyListeners();
    } catch (e) {
      print("❌ Error al buscar empleado: $e");
    }
  }

  void limpiarCampos() {
    nombresController.clear();
    apellidosController.clear();
    salarioController.clear();
    cuentaController.clear();
    fechaNacController.clear();
    idArea = null;
    idCargo = null;
    idContrato = null;
    idBanco = null;
    idEps = null;
    idPension = null;
    empleadoData = null;
    notifyListeners();
  }

  void seleccionarFechaNac(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      fechaNacController.text =
          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      notifyListeners();
    }
  }

  void setArea(int? val) {
    idArea = val;
    notifyListeners();
  }

  void setCargo(int? val) {
    idCargo = val;
    notifyListeners();
  }

  void setContrato(int? val) {
    idContrato = val;
    notifyListeners();
  }

  void setBanco(int? val) {
    idBanco = val;
    notifyListeners();
  }

  void setEps(int? val) {
    idEps = val;
    notifyListeners();
  }

  void setPension(int? val) {
    idPension = val;
    notifyListeners();
  }

  Future<void> actualizarEmpleado(BuildContext context) async {
    try {
      final Map<String, dynamic> data = {
        "id": empleadoData?['id'],
        "identificacion": empleadoData?['identificacion'],
        "nombres": nombresController.text,
        "apellidos": apellidosController.text,
        "salario": int.tryParse(salarioController.text) ?? 0,
        "cuentaBancaria": cuentaController.text,
        "fechaIngreso": empleadoData?['fechaIngreso'],
        "fechaNac": fechaNacController.text,
        "fechaRetiro": null,
        "estado": empleadoData?['estado'],
        "telefono": empleadoData?['telefono'],
        "correo": empleadoData?['correo'],
        "cargo": {"id": idCargo},
        "area": {"id": idArea},
        "tipoContrato": {"id": idContrato},
        "banco": {"id": idBanco},
        "eps": {"id": idEps},
        "pensiones": {"id": idPension},
      };

      await ApiService.actualizarEmpleado(data);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Empleado actualizado correctamente')),
      );
    } catch (e) {
      print("❌ Error actualizando empleado: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Error al actualizar empleado')),
      );
    }
  }

  Future<void> desactivarEmpleado(BuildContext context) async {
    try {
      final identificacion =
          empleadoData?['identificacion']; // Usamos la identificación

      if (identificacion == null) {
        throw Exception("Identificación no disponible");
      }

      print("🔄 Desactivando empleado con identificación: $identificacion");
      await ApiService.desactivarEmpleado(identificacion);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Empleado desactivado correctamente')),
      );
    } catch (e) {
      print("❌ Error desactivando empleado: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Error al desactivar empleado: $e')),
      );
    }
  }
}
