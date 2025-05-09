import 'package:equatable/equatable.dart';
import 'package:text_notes/data/dto/note/note.dart';

class NoteEntity extends Equatable {
  final int? id;
  final String title, content;
  final DateTime createdAt;

  const NoteEntity({
    this.id,
    required this.title,
    required this.content,
    required this.createdAt,
  });

  NoteDto toDto() => NoteDto(
    id: id,
    title: title,
    content: content,
    createdAt: createdAt,
  );

  @override
  List<Object?> get props => [id, title, content, createdAt];
}
