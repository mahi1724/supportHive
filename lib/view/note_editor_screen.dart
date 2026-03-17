// import 'package:flutter/material.dart';
// import 'package:supporthive1/model/note.dart';

// class NoteEditorScreen extends StatefulWidget {
//   const NoteEditorScreen({super.key});

//   @override
//   State<NoteEditorScreen> createState() => _NoteEditorScreenState();
// }

// class _NoteEditorScreenState extends State<NoteEditorScreen> {
//   final title = TextEditingController();
//   final content = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             TextField(
//               controller: title,
//               style: const TextStyle(color: Colors.white),
//               decoration: const InputDecoration(
//                 hintText: "Title",
//                 border: InputBorder.none,
//               ),
//             ),
//             Expanded(
//               child: TextField(
//                 controller: content,
//                 maxLines: null,
//                 expands: true,
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



////////////



import 'package:flutter/material.dart';
import 'package:supporthive1/controller/note_controller.dart';
import 'dart:async';

class NoteEditorScreen extends StatefulWidget {
  final NoteController controller;
  final int? noteIndex; // ⭐ NEW
  final String? title;
  final String? content;

  const NoteEditorScreen({
    super.key,
    required this.controller,
    this.noteIndex,
    this.title,
    this.content,
  });

  @override
  State<NoteEditorScreen> createState()
      => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  Timer? _debounce;

  // final NoteController controller = NoteController();

  @override
  @override
void initState() {
  super.initState();

  // ⭐ LOAD EXISTING NOTE
  titleController.text = widget.title ?? "";
  contentController.text = widget.content ?? "";

  widget.controller.setEditingIndex(widget.noteIndex);

  titleController.addListener(_autoSave);
  contentController.addListener(_autoSave);
}

  void _autoSave() {
  _debounce?.cancel();

  _debounce = Timer(const Duration(seconds: 1), () {
    widget.controller.autoSave(
      titleController.text,
      contentController.text,
    );
  });
}

  @override
void dispose() {
  _debounce?.cancel();
  titleController.dispose();
  contentController.dispose();
  super.dispose();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              style: const TextStyle(
                  color: Colors.white, fontSize: 20),
              decoration: const InputDecoration(
                hintText: "Title",
                border: InputBorder.none,
              ),
            ),
            Expanded(
              child: TextField(
                controller: contentController,
                expands: true,
                maxLines: null,
                style:
                    const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "Start writing...",
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}