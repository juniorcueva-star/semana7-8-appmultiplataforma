import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';
import 'screens.dart';
import 'student_repository.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(HttpStudentRepository()),
      child: const SchoolApp(),
    ),
  );
}

class SchoolApp extends StatelessWidget {
  const SchoolApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestión de alumnos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5947C8)),
        scaffoldBackgroundColor: const Color(0xFFF7F7FB),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(9)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 13,
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      home: Consumer<AppState>(
        builder: (context, state, _) {
          final Widget page;
          if (!state.signedIn) {
            page = const LoginScreen();
          } else {
            page = switch (state.page) {
              AppPage.menu => const MenuScreen(),
              AppPage.students => const StudentsScreen(),
              AppPage.register => const RegisterScreen(),
              AppPage.profile => const ProfileScreen(),
            };
          }
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            child: KeyedSubtree(
              key: ValueKey('${state.signedIn}-${state.page}'),
              child: page,
            ),
          );
        },
      ),
    );
  }
}
