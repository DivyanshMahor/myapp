import 'package:flutter/material.dart';
import 'package:myapp/screens/notes_screen.dart';

void main() {
  runApp(const NoteApp());
}

class NoteApp extends StatelessWidget {
  const NoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.brown, // Use a predefined MaterialColor
        scaffoldBackgroundColor: const Color.fromARGB(255, 238, 255, 0),
      ),
      home: const NotesScreen(),
    );
  }
}
