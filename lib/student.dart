class Student {
  const Student({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.grade,
  });

  final int id;
  final String firstName;
  final String lastName;
  final int grade;

  String get fullName => '$firstName $lastName';
  bool get approved => grade >= 11;
}

class TeacherProfile {
  const TeacherProfile({
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
  });

  final String name;
  final String email;
  final String phone;
  final String role;

  TeacherProfile copyWith({
    String? name,
    String? email,
    String? phone,
    String? role,
  }) => TeacherProfile(
    name: name ?? this.name,
    email: email ?? this.email,
    phone: phone ?? this.phone,
    role: role ?? this.role,
  );
}
