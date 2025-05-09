import 'package:flutter/material.dart';
import 'package:text_notes/core/di.dart';
import 'package:text_notes/ui/pages/notes_list_page.dart';
import 'package:text_notes/ui/providers/theme_mode_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDi();
  runApp(const NotesApp());
}

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: getIt<ThemeModeProvider>(),
      builder: (context, themeMode, child) {
        return MaterialApp(
          title: 'Text Notes',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          darkTheme: ThemeData.dark(),
          themeMode: themeMode,
          home: const NotesListPage(),
        );
      },
    );
  }
}
