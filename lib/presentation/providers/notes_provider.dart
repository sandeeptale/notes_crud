import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/note.dart';
import '../../domain/usecases/notes_usecases.dart';

class NotesProvider extends ChangeNotifier {
  final NotesUseCases _notesUseCases;
  List<Note> _notes = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';
  StreamSubscription? _notesSubscription;

  NotesProvider(this._notesUseCases) {
    _initNotesStream();

    // Listen to auth state changes to refresh notes when user changes
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        _initNotesStream();
      } else {
        _notes.clear();
        notifyListeners();
      }
    });
  }

  List<Note> get notes {
    final sortedNotes = List<Note>.from(_notes);
    sortedNotes.sort((a, b) {
      if (a.isPinned && !b.isPinned) return -1;
      if (!a.isPinned && b.isPinned) return 1;
      return b.timestamp.compareTo(a.timestamp);
    });
    return sortedNotes;
  }

  List<Note> get filteredNotes {
    if (_searchQuery.isEmpty) return notes;
    return notes.where((note) {
      final title = note.title.toLowerCase();
      final content = note.content.toLowerCase();
      final query = _searchQuery.toLowerCase();
      return title.contains(query) || content.contains(query);
    }).toList();
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  bool get isLoading => _isLoading;
  String? get error => _error;

  void _initNotesStream() {
    // Cancel existing subscription
    _notesSubscription?.cancel();

    // Check if user is authenticated
    if (FirebaseAuth.instance.currentUser == null) {
      _notes.clear();
      _isLoading = false;
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    _notesSubscription = _notesUseCases.getNotes().listen(
          (notes) {
        _notes = notes;
        _isLoading = false;
        _error = null;
        notifyListeners();
      },
      onError: (e) {
        _error = e.toString();
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  Future<void> addNote(String title, String content, int selectedColor) async {
    try {
      _error = null;
      final note = Note(
        id: '',
        title: title,
        content: content,
        timestamp: DateTime.now(),
        isPinned: false,
        color: selectedColor,
      );
      await _notesUseCases.addNote(note);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateNote(Note note) async {
    try {
      _error = null;
      await _notesUseCases.updateNote(note);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteNote(String id) async {
    try {
      _error = null;
      await _notesUseCases.deleteNote(id);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> togglePinNote(String id, bool isPinned) async {
    try {
      _error = null;
      await _notesUseCases.togglePinNote(id, isPinned);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Method to refresh notes manually
  void refreshNotes() {
    _initNotesStream();
  }

  @override
  void dispose() {
    _notesSubscription?.cancel();
    super.dispose();
  }
}
