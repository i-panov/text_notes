import 'package:isar/isar.dart';
import 'package:text_notes/domain/models/note.dart';

part 'note.g.dart';

@Collection(accessor: 'notes')
class NoteDto {
  final Id? id;
  final String title, content;
  final DateTime createdAt;

  const NoteDto({
    this.id,
    required this.title,
    required this.content,
    required this.createdAt,
  });

  NoteEntity toEntity() => NoteEntity(
    id: id,
    title: title,
    content: content,
    createdAt: createdAt,
  );
}
