import 'package:flutter/material.dart';
import 'package:supporthive1/service/note_service.dart';
import '../model/note.dart';

class NoteController extends ChangeNotifier {
  final NoteService _service = NoteService();

  List<Note> notes = [];
  String searchQuery = "";

  NoteController() {
    loadNotes();
  }

  void loadNotes() {
    notes = _service.fetchNotes();
    notifyListeners();
  }

int? _editingIndex;

void autoSave(String title, String content) {
  // ❌ ignore empty note
  if (title.trim().isEmpty && content.trim().isEmpty) return;

  // ✅ auto title if empty
  if (title.trim().isEmpty) {
    final now = DateTime.now();
    title =
        "${now.day}/${now.month} ${now.hour}:${now.minute.toString().padLeft(2, '0')}";
  }

  final note = Note(
    title: title,
    content: content,
    date: DateTime.now(),
  );

  // ✅ FIRST TIME → CREATE
  if (_editingIndex == null) {
    _service.add(note);
    _editingIndex = notes.length;
  } 
  // ✅ AFTER → UPDATE SAME NOTE
  else {
    _service.update(_editingIndex!, note);
  }

  loadNotes();
}

  void startNewNote() {
  _editingIndex = null;
}

void setEditingIndex(int? index) {
  _editingIndex = index;
}

  void addNote(Note note) {
    _service.add(note);
    loadNotes();
  }

  void deleteNote(int index) {
    _service.delete(index);
    loadNotes();
  }

  void updateNote(int index, Note note) {
    _service.update(index, note);
    loadNotes();
  }

  List<Note> get filteredNotes {
    if (searchQuery.isEmpty) return notes;

    return notes
        .where(
          (n) =>
              n.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
              n.content.toLowerCase().contains(searchQuery.toLowerCase()),
        )
        .toList();
  }

  void updateSearch(String value) {
    searchQuery = value;
    notifyListeners();
  }
}
