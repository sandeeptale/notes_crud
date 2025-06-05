import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/note.dart';

abstract class FirebaseNotesDataSource {
  Stream<List<Note>> getNotes();
  Future<Note> getNote(String id);
  Future<void> addNote(Note note);
  Future<void> updateNote(Note note);
  Future<void> deleteNote(String id);
  Future<void> togglePinNote(String id, bool isPinned);
}

class FirebaseNotesDataSourceImpl implements FirebaseNotesDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference get _notesCollection {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception('User not authenticated');
    }
    return _firestore.collection('users').doc(userId).collection('notes');
  }

  @override
  Stream<List<Note>> getNotes() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    return _notesCollection
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Note(
          id: doc.id,
          title: data['title'] as String? ?? '',
          content: data['content'] as String? ?? '',
          timestamp: (data['timestamp'] as Timestamp).toDate(),
          isPinned: data['isPinned'] as bool? ?? false,
          color: data['color'] as int? ?? 0xFFFFFFFF,
        );
      }).toList();
    });
  }

  @override
  Future<Note> getNote(String id) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    final doc = await _notesCollection.doc(id).get();
    if (!doc.exists) {
      throw Exception('Note not found');
    }

    final data = doc.data() as Map<String, dynamic>;
    return Note(
      id: doc.id,
      title: data['title'] as String? ?? '',
      content: data['content'] as String? ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      isPinned: data['isPinned'] as bool? ?? false,
      color: data['color'] as int? ?? 0xFFFFFFFF,
    );
  }

  @override
  Future<void> addNote(Note note) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    await _notesCollection.add({
      'title': note.title,
      'content': note.content,
      'timestamp': Timestamp.fromDate(note.timestamp),
      'isPinned': note.isPinned,
      'color': note.color,
      'userId': userId, // Extra safety measure
    });
  }

  @override
  Future<void> updateNote(Note note) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    await _notesCollection.doc(note.id).update({
      'title': note.title,
      'content': note.content,
      'timestamp': Timestamp.fromDate(note.timestamp),
      'isPinned': note.isPinned,
      'color': note.color,
      'userId': userId, // Extra safety measure
    });
  }

  @override
  Future<void> deleteNote(String id) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    await _notesCollection.doc(id).delete();
  }

  @override
  Future<void> togglePinNote(String id, bool isPinned) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    await _notesCollection.doc(id).update({
      'isPinned': isPinned,
    });
  }
}
