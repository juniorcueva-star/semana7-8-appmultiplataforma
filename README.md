# Gestión de alumnos · Sección A

Aplicación académica en **Flutter y Dart** basada en las cinco pantallas de la consigna: inicio de sesión, menú, listado, registro de alumnos y perfil.

El diseño usa el logo TE proporcionado para el proyecto (`assets/te_logo.png`) y una paleta cian y blanca basada en ese logo.

## Funciones

- Inicio de sesión de demostración: correo válido y una contraseña de al menos cuatro caracteres. No hay autenticación real.
- Listado con búsqueda por nombre, nota y estado. Se aprueba con **11 a 20**.
- Registro con validación de nombre, apellido y nota de **0 a 20**.
- Perfil editable.
- Botón de sincronización HTTP que obtiene usuarios de [JSONPlaceholder](https://jsonplaceholder.typicode.com/users). La API no aporta notas; la app asigna notas de ejemplo para mostrar los estados.
- Estado de la app mediante `provider` y `ChangeNotifier`.

Los alumnos agregados y los cambios de perfil se conservan **solo mientras la app está abierta**. La sincronización requiere internet. El proyecto no incluye servidor ni base de datos.

## Requisitos y ejecución

Instala Flutter estable y ejecuta:

```bash
flutter pub get
flutter run -d chrome
```

Para Android, usa un emulador o dispositivo conectado y ejecuta `flutter run`.

## Comprobaciones

```bash
flutter analyze
flutter test
flutter build web --release
```

## Entregables

- Código fuente Flutter en `lib/`.
- Pruebas en `test/`.
- Capturas en `docs/`.
- Documento explicativo en `docs/Informe_gestion_alumnos.docx`.

## Temas del curso aplicados

| Semana | Aplicación en el proyecto |
|---|---|
| 1 Dart | Clases, listas, funciones y tipos |
| 2 Clases abstractas | `StudentRepository` como contrato del servicio |
| 3 Flutter | `MaterialApp`, `Scaffold` y pantallas |
| 4 Widgets y const | Widgets reutilizables y constructores `const` |
| 5 Funciones con argumentos | Registro, búsqueda, navegación y actualización del perfil |
| 6 ListView | Listado dinámico de alumnos |
| 7 TextForms | `Form`, `TextFormField` y validadores |
| 8 Provider y HTTP | `ChangeNotifierProvider`, `Consumer` y `http.Client.get` |
