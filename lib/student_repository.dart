import 'dart:convert';

import 'package:http/http.dart' as http;

import 'student.dart';

// Semana 2: una clase abstracta define el contrato de obtención de alumnos.
abstract class StudentRepository {
  Future<List<Student>> fetchStudents();
}

class HttpStudentRepository implements StudentRepository {
  HttpStudentRepository({http.Client? client})
    : _client = client ?? http.Client();

  final http.Client _client;

  @override
  Future<List<Student>> fetchStudents() async {
    final response = await _client
        .get(Uri.https('jsonplaceholder.typicode.com', '/users'))
        .timeout(const Duration(seconds: 10));
    if (response.statusCode != 200) {
      throw Exception('El servidor respondió ${response.statusCode}');
    }
    final users = jsonDecode(response.body) as List<dynamic>;
    return users.map((item) {
      final user = item as Map<String, dynamic>;
      final parts = (user['name'] as String).trim().split(RegExp(r'\s+'));
      final id = user['id'] as int;
      return Student(
        id: 100 + id,
        firstName: parts.first,
        lastName: parts.skip(1).join(' '),
        // JSONPlaceholder no proporciona notas; se asignan solo para la demo.
        grade: 8 + (id * 3) % 13,
      );
    }).toList();
  }
}
