import 'package:freezed_annotation/freezed_annotation.dart';

class Note {
  final String id;
  final String title;
  final String content;
  final DateTime timestamp;
  final bool isPinned;
  final int color;

  const Note({
    required this.id,
    required this.title,
    required this.content,
    required this.timestamp,
    this.isPinned = false,
    this.color = 0xFFFFFFFF,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isPinned: json['isPinned'] as bool? ?? false,
      color: json['color'] as int? ?? 0xFFFFFFFF,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'isPinned': isPinned,
      'color': color,
    };
  }

  Note copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? timestamp,
    bool? isPinned,
    int? color,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      isPinned: isPinned ?? this.isPinned,
      color: color ?? this.color,
    );
  }
}
