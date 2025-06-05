import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import '../../../domain/entities/note.dart';
import '../../providers/notes_provider.dart';

class NoteDetailScreen extends StatefulWidget {
  final String? noteId;

  const NoteDetailScreen({super.key, this.noteId});

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  bool _isPinned = false;
  bool _isLoading = false;
  bool _isEditing = false;
  Note? _note;
  int _selectedColor = 0xFFFFFFFF;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.noteId != null;
    if (_isEditing) {
      _loadNote();
    }
  }

  Future<void> _loadNote() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final notesProvider = Provider.of<NotesProvider>(context, listen: false);
      final notes = notesProvider.notes;
      _note = notes.firstWhere(
            (note) => note.id == widget.noteId,
        orElse: () => throw Exception('Note not found'),
      );
      _titleController.text = _note!.title;
      _contentController.text = _note!.content;
      _isPinned = _note!.isPinned;
      _selectedColor = _note!.color;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading note: $e')),
        );
        Navigator.of(context).pop();
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _saveNote() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty && content.isEmpty) {
      Navigator.of(context).pop();
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final notesProvider = Provider.of<NotesProvider>(context, listen: false);

      if (_isEditing && _note != null) {
        final updatedNote = Note(
          id: _note!.id,
          title: title,
          content: content,
          timestamp: DateTime.now(),
          isPinned: _isPinned,
          color: _selectedColor,
        );
        await notesProvider.updateNote(updatedNote);
      } else {
        await notesProvider.addNote(title, content, _selectedColor);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isEditing ? 'Note updated successfully' : 'Note created successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving note: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Note' : 'New Note'),
        actions: [
          IconButton(
            icon: Icon(_isPinned ? Icons.push_pin : Icons.push_pin_outlined),
            onPressed: () {
              setState(() {
                _isPinned = !_isPinned;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _isLoading ? null : _saveNote,
          ),
        ],
      ),
      body: _isLoading && _isEditing
          ? const Center(child: CircularProgressIndicator())
          : Container(
        color: Color(_selectedColor),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: 'Title',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                ),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  const Text("Color: "),
                  GestureDetector(
                    onTap: _showColorPickerDialog,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Color(_selectedColor),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.black26),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Divider(),
              Expanded(
                child: TextField(
                  controller: _contentController,
                  decoration: const InputDecoration(
                    hintText: 'Note content',
                    border: InputBorder.none,
                  ),
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showColorPickerDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pick a note color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: Color(_selectedColor),
              onColorChanged: (color) {
                setState(() {
                  _selectedColor = color.value;
                });
              },
              enableAlpha: false,
              showLabel: false,
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Done'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}
