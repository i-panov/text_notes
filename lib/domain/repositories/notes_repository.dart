import 'package:text_notes/data/dto/note/note.dart';

abstract interface class NotesRepository {
  Future<List<NoteDto>> getAll({
    bool desc = false,
    String search = '',
  });

  Future<NoteDto?> get(int id);

  Future<void> save(NoteDto entity);

  Future<void> remove(int id);
}
