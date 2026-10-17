import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestion_alumnos/app_state.dart';
import 'package:gestion_alumnos/main.dart';
import 'package:gestion_alumnos/student.dart';
import 'package:gestion_alumnos/student_repository.dart';
import 'package:provider/provider.dart';

class FakeRepository implements StudentRepository {
  @override
  Future<List<Student>> fetchStudents() async => [
    const Student(id: 101, firstName: 'Elena', lastName: 'Paz', grade: 19),
  ];
}

void main() {
  test('registra alumnos, calcula aprobado y evita duplicados HTTP', () async {
    final state = AppState(FakeRepository());
    state.addStudent(firstName: 'Pedro', lastName: 'Vega', grade: 10);
    expect(state.students.first.fullName, 'Pedro Vega');
    expect(state.students.first.approved, isFalse);
    await state.syncStudents();
    await state.syncStudents();
    expect(state.students.where((s) => s.id == 101).length, 1);
    state.setSearch('elena');
    expect(state.filteredStudents.single.fullName, 'Elena Paz');
  });

  testWidgets('permite iniciar sesión y entrar al listado', (tester) async {
    final state = AppState(FakeRepository());
    await tester.pumpWidget(
      ChangeNotifierProvider.value(value: state, child: const SchoolApp()),
    );
    expect(find.text('Iniciar sesión'), findsOneWidget);
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Contraseña'),
      '1234',
    );
    await tester.tap(find.text('INGRESAR'));
    await tester.pumpAndSettle();
    expect(find.text('Menú'), findsOneWidget);
    await tester.tap(find.text('Listar alumnos'));
    await tester.pumpAndSettle();
    expect(find.text('Ana Torres'), findsOneWidget);
    expect(find.text('Desaprobado'), findsOneWidget);
  });
}
