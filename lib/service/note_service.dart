import 'package:hive/hive.dart';
import '../model/note.dart';

class NoteService {
  final Box box = Hive.box('notesBox');

  List<Note> fetchNotes() {
    return box.values
        .map((e) => Note.fromMap(Map<String, dynamic>.from(e)))
        .toList();
  }

  void add(Note note) => box.add(note.toMap());

  void delete(int index) => box.deleteAt(index);

  void update(int index, Note note) =>
      box.putAt(index, note.toMap());
}