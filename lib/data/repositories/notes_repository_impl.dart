
import '../../domain/entities/note.dart';
import '../../domain/repositories/notes_repository.dart';
import '../datasources/firebase_notes_datasource.dart';

class NotesRepositoryImpl implements NotesRepository {
  final FirebaseNotesDataSource dataSource;

  NotesRepositoryImpl(this.dataSource);

  @override
  Stream<List< Note>> getNotes() {
    return dataSource.getNotes();
  }

  @override
  Future<Note> getNote(String id) {
    return dataSource.getNote(id);
  }

  @override
  Future<void> addNote(Note note) {
    return dataSource.addNote(note);
  }

  @override
  Future<void> updateNote(Note note) {
    return dataSource.updateNote(note);
  }

  @override
  Future<void> deleteNote(String id) {
    return dataSource.deleteNote(id);
  }

  @override
  Future<void> togglePinNote(String id, bool isPinned) {
    return dataSource.togglePinNote(id, isPinned);
  }
}
