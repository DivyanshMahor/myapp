import 'package:flutter/material.dart';
import 'package:myapp/database/notes_database.dart';
import 'package:myapp/screens/note_card.dart';
import 'package:myapp/screens/note_dialog.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  List<Map<String, dynamic>> notes = [];

  @override
  void initState() {
    super.initState();
    fetchNotes();
  }

  Future<void> fetchNotes() async {
    final fetchedNotes = await NotesDatabase.instance.getNotes();

    setState(() {
      notes = fetchedNotes;
    });
  }

  final List<Color> noteColors = [
    Colors.pinkAccent, // Super bright pink
    Colors.lime, // Toxic green
    Colors.amberAccent, // Flashy yellow
    Colors.deepOrangeAccent, // Burnt orange glow
    Colors.lightGreenAccent, // Radioactive green
    Colors.cyanAccent, // Neon cyan
    Colors.redAccent, // High blood red
    Colors.purpleAccent, // Loud purple
    Colors.yellowAccent, // Solar flare yellow
    Colors.tealAccent, // Awkward teal
    Colors.indigoAccent, // Shouting blue
    Colors.orangeAccent, // Blinding orange
    Colors.blueAccent, // In-your-face blue
    Color(0xFF00FF00), // HTML green (screams old-school web)
    Color(0xFFFF00FF), // Magenta — pure eye damage
  ];

  void showNoteDialog({
    int? id,
    String? title,
    String? content,
    int colorIndex = 0,
  }) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return NoteDialog(
          colorIndex: colorIndex,
          noteColors: noteColors,
          noteId: id,
          title: title,
          content: content,
          onNoteSaved: (
            newTitle,
            newDescription,
            selectedColorIndex,
            currentDate,
          ) async {
            if (id == null) {
              await NotesDatabase.instance.addNote(
                newTitle,
                newDescription,
                currentDate,
                selectedColorIndex,
              );
            } else {
              await NotesDatabase.instance.updateNote(
                newTitle,
                newDescription,
                currentDate,
                selectedColorIndex,
                id,
              );
            }
            fetchNotes(); //refresh after save
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 0, 234),

        // elevation: 10,
        title: const Text(
          'Notes',
          style: TextStyle(
            fontSize: 30,
            color: Color.fromARGB(255, 241, 241, 241),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showNoteDialog();
        },
        backgroundColor: Colors.white,
        child: const Icon(Icons.add, color: Colors.black), // or Icons.note_add
      ),

      body:
          notes.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.note_add_outlined,
                      size: 88,
                      color: Colors.black,
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      'No Notes Found',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )
              : Padding(
                padding: const EdgeInsets.all(20),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    final note = notes[index];

                    return NoteCard(
                      note: note,
                      //noteColors: noteColors,
                      onDelete: () async {
                        await NotesDatabase.instance.deleteNote(note['id']);
                        fetchNotes();
                      },
                      onTap: () {
                        showNoteDialog(
                          id: note['id'],
                          title: note['title'],
                          content: note['description'],
                          colorIndex: note['color'],
                        );
                      },
                      noteColors: noteColors,
                    );
                  },
                ),
              ),
    );
  }
}
