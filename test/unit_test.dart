import 'package:flutter_test/flutter_test.dart';
import 'package:text_notes/domain/models/note.dart';

void main() {
  test('NoteEntity toDto conversion', () {
    final note = NoteEntity(
      id: 1,
      title: 'Test Title',
      content: 'Test Content',
      createdAt: DateTime(2025, 5, 9),
    );

    final dto = note.toDto();

    expect(dto.id, 1);
    expect(dto.title, 'Test Title');
    expect(dto.content, 'Test Content');
    expect(dto.createdAt, DateTime(2025, 5, 9));
  });

  test('NoteEntity equality', () {
    final note1 = NoteEntity(
      id: 1,
      title: 'Test Title',
      content: 'Test Content',
      createdAt: DateTime(2025, 5, 9),
    );

    final note2 = NoteEntity(
      id: 1,
      title: 'Test Title',
      content: 'Test Content',
      createdAt: DateTime(2025, 5, 9),
    );

    expect(note1, equals(note2));
  });
}
