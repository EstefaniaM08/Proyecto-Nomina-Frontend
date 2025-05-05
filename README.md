# Sistema de Nómina - Flutter + MVVM

Aplicación móvil desarrollada con **Flutter** para la gestión de empleados, que incluye funcionalidades como autenticación, registro y consulta de personal. El proyecto utiliza el patrón arquitectónico **MVVM (Model - View - ViewModel)**, lo que permite mantener una clara separación entre la interfaz de usuario y la lógica del negocio.

---

## ¿Qué es MVVM?

**MVVM (Model - View - ViewModel)** es un patrón de arquitectura de software que separa:

- **Model**: representa los datos (ej. clases como `Usuario`, datos JSON, etc.).
- **View**: la interfaz gráfica de usuario (widgets en Flutter).
- **ViewModel**: contiene la lógica de presentación. Se comunica con los modelos y expone datos a la vista. En Flutter, se apoya en `ChangeNotifier` y `Provider`.

### Ventajas de MVVM en Flutter

- Facilita el mantenimiento del código.
- Mejora la escalabilidad del proyecto.
- Evita duplicación de lógica en las vistas.
- Permite realizar pruebas unitarias sin depender de la UI.
- Separa completamente el diseño (UI) de la lógica del negocio (ViewModel).

---

## Estructura del Proyecto

```plaintext
lib/
├── models/                # Estructuras de datos (Usuario, etc.)
├── services/              # Consumo de APIs REST
├── viewmodels/            # Controladores con ChangeNotifier (login, registro, etc.)
├── views/                 # Interfaces gráficas (pantallas)
├── main.dart              # Inicio de la app y configuración de rutas/providers
```
---

## Cómo ejecutar el proyecto

### 1. Clonar el repositorio

```bash
git clone https://github.com/EstefaniaM08/Proyecto-Nomina-Frontend.git
cd Proyecto-Nomina-Frontend
```
### 2. Instalar las dependencias

```bash
flutter pub get
```

### 3. Ejecutar la aplicación

```bash
flutter run
```