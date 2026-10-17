import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';
import 'student.dart';

const purple = Color(0xFF5947C8);

class PageFrame extends StatelessWidget {
  const PageFrame({
    super.key,
    required this.title,
    required this.child,
    this.actions,
    this.showBack = true,
  });

  final String title;
  final Widget child;
  final List<Widget>? actions;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: purple,
        foregroundColor: Colors.white,
        leading: showBack
            ? IconButton(
                tooltip: 'Volver al menú',
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.read<AppState>().goTo(AppPage.menu),
              )
            : null,
        actions: actions,
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: child,
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController(text: 'maria.gonzalez@correo.com');
  final _password = TextEditingController();
  bool _visible = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 390),
            child: Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.school_rounded, color: purple, size: 72),
                      const SizedBox(height: 14),
                      Text(
                        'Iniciar sesión',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Ingresa tus datos para continuar',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _email,
                        decoration: const InputDecoration(
                          labelText: 'Correo electrónico',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) =>
                            value != null &&
                                RegExp(
                                  r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                                ).hasMatch(value.trim())
                            ? null
                            : 'Ingresa un correo válido',
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _password,
                        decoration: InputDecoration(
                          labelText: 'Contraseña',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            tooltip: _visible
                                ? 'Ocultar contraseña'
                                : 'Mostrar contraseña',
                            onPressed: () =>
                                setState(() => _visible = !_visible),
                            icon: Icon(
                              _visible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                          ),
                        ),
                        obscureText: !_visible,
                        validator: (value) => value != null && value.length >= 4
                            ? null
                            : 'Escribe al menos 4 caracteres',
                      ),
                      const SizedBox(height: 20),
                      FilledButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<AppState>().signIn(_email.text);
                          }
                        },
                        child: const Text('INGRESAR'),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Demo académica: cualquier contraseña de 4 o más caracteres.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return PageFrame(
      title: 'Menú',
      showBack: false,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Sección A',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Bienvenida, ${state.profile.name}',
            style: const TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 22),
          _MenuTile(
            icon: Icons.person_add_alt_1,
            title: 'Registrar alumno',
            onTap: () => state.goTo(AppPage.register),
          ),
          _MenuTile(
            icon: Icons.list_alt,
            title: 'Listar alumnos',
            onTap: () => state.goTo(AppPage.students),
          ),
          _MenuTile(
            icon: Icons.person,
            title: 'Perfil',
            onTap: () => state.goTo(AppPage.profile),
          ),
          _MenuTile(
            icon: Icons.logout,
            title: 'Cerrar sesión',
            color: Colors.red,
            onTap: state.signOut,
          ),
          const SizedBox(height: 20),
          const Text(
            'Los cambios se conservan mientras la app permanece abierta.',
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.color = purple,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: 10),
    child: ListTile(
      leading: Icon(icon, color: color),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    ),
  );
}

class StudentsScreen extends StatelessWidget {
  const StudentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final students = state.filteredStudents;
    return PageFrame(
      title: 'Alumnos',
      actions: [
        IconButton(
          tooltip: 'Cargar alumnos de ejemplo por HTTP',
          icon: const Icon(Icons.sync),
          onPressed: state.loading ? null : () => state.syncStudents(),
        ),
        IconButton(
          tooltip: 'Registrar alumno',
          icon: const Icon(Icons.add),
          onPressed: () => state.goTo(AppPage.register),
        ),
      ],
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 10),
            child: TextField(
              onChanged: state.setSearch,
              decoration: const InputDecoration(
                hintText: 'Buscar alumno...',
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          if (state.loading) const LinearProgressIndicator(),
          if (state.syncError != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                state.syncError!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${students.length} alumno(s) · Usa sincronizar para cargar datos HTTP',
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ),
          ),
          Expanded(
            child: students.isEmpty
                ? const Center(child: Text('No se encontraron alumnos'))
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(12, 4, 12, 20),
                    itemCount: students.length,
                    itemBuilder: (context, index) =>
                        _StudentTile(student: students[index]),
                  ),
          ),
        ],
      ),
    );
  }
}

class _StudentTile extends StatelessWidget {
  const _StudentTile({required this.student});

  final Student student;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Color(0xFFE9E4FF),
          child: Icon(Icons.school, color: purple),
        ),
        title: Text(
          student.fullName,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text('Nota: ${student.grade}'),
        trailing: Chip(
          label: Text(
            student.approved ? 'Aprobado' : 'Desaprobado',
            style: const TextStyle(fontSize: 11),
          ),
          backgroundColor: student.approved
              ? const Color(0xFFDDF5E2)
              : const Color(0xFFFFE1E1),
          side: BorderSide(
            color: student.approved ? Colors.green : Colors.redAccent,
          ),
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _grade = TextEditingController();

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _grade.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageFrame(
      title: 'Registrar alumno',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Datos del alumno',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _firstName,
                    decoration: const InputDecoration(
                      labelText: 'Nombre del alumno',
                    ),
                    textCapitalization: TextCapitalization.words,
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Ingresa el nombre'
                        : null,
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _lastName,
                    decoration: const InputDecoration(labelText: 'Apellido'),
                    textCapitalization: TextCapitalization.words,
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Ingresa el apellido'
                        : null,
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _grade,
                    decoration: const InputDecoration(
                      labelText: 'Nota (0 a 20)',
                      suffixIcon: Icon(Icons.school_outlined),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      final grade = int.tryParse(value ?? '');
                      return grade != null && grade >= 0 && grade <= 20
                          ? null
                          : 'Ingresa una nota de 0 a 20';
                    },
                  ),
                  const SizedBox(height: 22),
                  FilledButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<AppState>().addStudent(
                          firstName: _firstName.text,
                          lastName: _lastName.text,
                          grade: int.parse(_grade.text),
                        );
                      }
                    },
                    child: const Text('GUARDAR'),
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

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _editing = false;
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _role = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _role.dispose();
    super.dispose();
  }

  void _startEdit(TeacherProfile profile) {
    _name.text = profile.name;
    _email.text = profile.email;
    _phone.text = profile.phone;
    _role.text = profile.role;
    setState(() => _editing = true);
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<AppState>().profile;
    return PageFrame(
      title: 'Perfil',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: _editing
                ? _editForm(context)
                : _profileContent(context, profile),
          ),
        ),
      ),
    );
  }

  Widget _profileContent(BuildContext context, TeacherProfile profile) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Center(
            child: CircleAvatar(
              radius: 45,
              backgroundColor: Color(0xFFE9E4FF),
              child: Icon(Icons.person, size: 55, color: purple),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            profile.name,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            profile.email,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
          const Divider(height: 30),
          _detail(Icons.person_outline, 'Nombre', profile.name),
          _detail(Icons.email_outlined, 'Correo', profile.email),
          _detail(Icons.phone_outlined, 'Teléfono', profile.phone),
          _detail(Icons.work_outline, 'Rol', profile.role),
          const SizedBox(height: 18),
          OutlinedButton(
            onPressed: () => _startEdit(profile),
            child: const Text('EDITAR PERFIL'),
          ),
        ],
      );

  Widget _detail(IconData icon, String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        Icon(icon, size: 20, color: purple),
        const SizedBox(width: 10),
        Text('$label:', style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(width: 8),
        Expanded(child: Text(value, textAlign: TextAlign.end)),
      ],
    ),
  );

  Widget _editForm(BuildContext context) => Form(
    key: _formKey,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Editar perfil', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 18),
        TextFormField(
          controller: _name,
          decoration: const InputDecoration(labelText: 'Nombre'),
          validator: (value) => value == null || value.trim().isEmpty
              ? 'Ingresa tu nombre'
              : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _email,
          decoration: const InputDecoration(labelText: 'Correo'),
          keyboardType: TextInputType.emailAddress,
          validator: (value) =>
              value != null &&
                  RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value.trim())
              ? null
              : 'Ingresa un correo válido',
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _phone,
          decoration: const InputDecoration(labelText: 'Teléfono'),
          keyboardType: TextInputType.phone,
          validator: (value) => value == null || value.trim().isEmpty
              ? 'Ingresa tu teléfono'
              : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _role,
          decoration: const InputDecoration(labelText: 'Rol'),
          validator: (value) =>
              value == null || value.trim().isEmpty ? 'Ingresa tu rol' : null,
        ),
        const SizedBox(height: 18),
        FilledButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              context.read<AppState>().updateProfile(
                TeacherProfile(
                  name: _name.text.trim(),
                  email: _email.text.trim(),
                  phone: _phone.text.trim(),
                  role: _role.text.trim(),
                ),
              );
              setState(() => _editing = false);
            }
          },
          child: const Text('GUARDAR CAMBIOS'),
        ),
        TextButton(
          onPressed: () => setState(() => _editing = false),
          child: const Text('Cancelar'),
        ),
      ],
    ),
  );
}
