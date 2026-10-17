import 'package:flutter/foundation.dart';

import 'student.dart';
import 'student_repository.dart';

enum AppPage { menu, students, register, profile }

class AppState extends ChangeNotifier {
  AppState(this._repository);

  final StudentRepository _repository;
  final List<Student> _students = [
    const Student(id: 1, firstName: 'Ana', lastName: 'Torres', grade: 18),
    const Student(id: 2, firstName: 'Luis', lastName: 'García', grade: 12),
    const Student(id: 3, firstName: 'María', lastName: 'López', grade: 9),
    const Student(id: 4, firstName: 'Carlos', lastName: 'Ruiz', grade: 15),
  ];

  bool signedIn = false;
  bool loading = false;
  String? syncError;
  AppPage page = AppPage.menu;
  String search = '';
  TeacherProfile profile = const TeacherProfile(
    name: 'María González',
    email: 'maria.gonzalez@correo.com',
    phone: '912345678',
    role: 'Docente',
  );

  List<Student> get students => List.unmodifiable(_students);

  List<Student> get filteredStudents => _students.where((student) {
    return student.fullName.toLowerCase().contains(search.toLowerCase().trim());
  }).toList();

  void signIn(String email) {
    profile = profile.copyWith(email: email.trim());
    signedIn = true;
    page = AppPage.menu;
    notifyListeners();
  }

  void signOut() {
    signedIn = false;
    page = AppPage.menu;
    search = '';
    notifyListeners();
  }

  void goTo(AppPage next) {
    page = next;
    notifyListeners();
  }

  void setSearch(String value) {
    search = value;
    notifyListeners();
  }

  void addStudent({
    required String firstName,
    required String lastName,
    required int grade,
  }) {
    final maxId = _students.fold<int>(
      0,
      (value, student) => student.id > value ? student.id : value,
    );
    _students.insert(
      0,
      Student(
        id: maxId + 1,
        firstName: firstName.trim(),
        lastName: lastName.trim(),
        grade: grade,
      ),
    );
    search = '';
    page = AppPage.students;
    notifyListeners();
  }

  void updateProfile(TeacherProfile value) {
    profile = value;
    page = AppPage.profile;
    notifyListeners();
  }

  Future<void> syncStudents() async {
    if (loading) return;
    loading = true;
    syncError = null;
    notifyListeners();
    try {
      final incoming = await _repository.fetchStudents();
      final existingIds = _students.map((student) => student.id).toSet();
      _students.addAll(
        incoming.where((student) => !existingIds.contains(student.id)),
      );
    } catch (_) {
      syncError =
          'No se pudieron cargar los alumnos de ejemplo. Revisa tu conexión.';
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
