
import '../entities/note.dart';

abstract class NotesRepository {
  Stream<List<Note>> getNotes();
  Future<Note> getNote(String id);
  Future<void> addNote(Note note);
  Future<void> updateNote(Note note);
  Future<void> deleteNote(String id);
  Future<void> togglePinNote(String id, bool isPinned);
}
