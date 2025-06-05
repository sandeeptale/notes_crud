
import '../entities/note.dart';
import '../repositories/notes_repository.dart';

class NotesUseCases {
  final NotesRepository repository;

  NotesUseCases(this.repository);

  Stream<List<Note>> getNotes() {
    return repository.getNotes();
  }

  Future<Note> getNote(String id) {
    return repository.getNote(id);
  }

  Future<void> addNote(Note note) {
    return repository.addNote(note);
  }

  Future<void> updateNote(Note note) {
    return repository.updateNote(note);
  }

  Future<void> deleteNote(String id) {
    return repository.deleteNote(id);
  }

  Future<void> togglePinNote(String id, bool isPinned) {
    return repository.togglePinNote(id, isPinned);
  }
}
