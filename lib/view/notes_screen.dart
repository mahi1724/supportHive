import 'package:flutter/material.dart';
import '../../controller/note_controller.dart';
import 'note_editor_screen.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final NoteController controller = NoteController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),

      /// ───────── APP BAR ─────────
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),

        title: Row(
          children: [
            const Icon(
              Icons.note_alt_outlined,
              color: Color.fromARGB(255, 0, 0, 0),
              size: 30,
            ),

            const SizedBox(width: 10),

            Expanded(
              child: TextField(
                style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                decoration: const InputDecoration(
                  hintText: "NOTES",
                  hintStyle: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),

                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                  border: InputBorder.none,
                ),
                onChanged: controller.updateSearch,
              ),
            ),
          ],
        ),
      ),

      /// ───────── NOTES GRID ─────────
      body: AnimatedBuilder(
        animation: controller,
        builder: (_, __) {
          final notes = controller.filteredNotes;

          if (notes.isEmpty) {
            return const Center(
              child: Text(
                "No Notes Yet",
                style: TextStyle(color: Colors.white54),
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: notes.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.85,
            ),
            itemBuilder: (_, index) {
              final note = notes[index];

              return Dismissible(
                key: Key(note.date.toString()),
                direction: DismissDirection.endToStart,

                /// DELETE NOTE
                onDismissed: (_) {
                  controller.deleteNote(index);
                },

                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    color: Colors.red.shade700,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),

                /// OPEN NOTE
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => NoteEditorScreen(
                          controller: controller,
                          noteIndex: index,
                          title: note.title,
                          content: note.content,
                        ),
                      ),
                    );
                  },

                  /// NOTE CARD UI
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      // color: const Color.fromARGB(255, 252, 236, 252),
                      color: const Color.fromARGB(255, 226, 247, 246),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          note.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: Text(
                            note.content,
                            overflow: TextOverflow.fade,
                            style: const TextStyle(
                              color: Color.fromARGB(179, 48, 46, 46),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),

      /// ───────── ADD NEW NOTE BUTTON ─────────
      floatingActionButton: FloatingActionButton(
        backgroundColor:const Color.fromARGB(255, 226, 247, 246),

        onPressed: () async {
          // start fresh diary
          controller.startNewNote();

          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => NoteEditorScreen(controller: controller),
            ),
          );
        },
        child: const Icon(Icons.edit),
      ),
    );
  }
}


// import 'dart:async';
// import 'package:flutter/material.dart';
// import '/controller/note_controller.dart';

// class NoteEditorScreen extends StatefulWidget {
//   final NoteController controller;

//   const NoteEditorScreen({
//     super.key,
//     required this.controller,
//   });

//   @override
//   State<NoteEditorScreen> createState()
//       => _NoteEditorScreenState();
// }

// class _NoteEditorScreenState extends State<NoteEditorScreen> {
//   final titleController = TextEditingController();
//   final contentController = TextEditingController();
//   final NoteController controller = NoteController();
//   Timer? _debounce;

//   @override
//   void initState() {
//     super.initState();

//     titleController.addListener(_autoSave);
//     contentController.addListener(_autoSave);
//   }

//   void _autoSave() {
//     _debounce?.cancel();

//     _debounce = Timer(const Duration(seconds: 1), () {
//       widget.controller.autoSave(
//         titleController.text,
//         contentController.text,
//       );
//     });
//   }

//   @override
//   void dispose() {
//     _debounce?.cancel();
//     titleController.dispose();
//     contentController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(backgroundColor: Colors.black),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             TextField(
//               controller: titleController,
//               style:
//                   const TextStyle(color: Colors.white, fontSize: 20),
//               decoration: const InputDecoration(
//                 hintText: "Title",
//                 border: InputBorder.none,
//               ),
//             ),
//             Expanded(
//               child: TextField(
//                 controller: contentController,
//                 expands: true,
//                 maxLines: null,
//                 style: const TextStyle(color: Colors.white),
//                 decoration: const InputDecoration(
//                   hintText: "Start writing...",
//                   border: InputBorder.none,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }