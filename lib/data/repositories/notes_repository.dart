import 'package:isar/isar.dart';
import 'package:text_notes/data/dto/note/note.dart';
import 'package:text_notes/domain/repositories/notes_repository.dart';

class NotesRepositoryImpl implements NotesRepository {
  final Isar isar;

  NotesRepositoryImpl({required this.isar});

  @override
  Future<List<NoteDto>> getAll({
    bool desc = false,
    String search = '',
  }) {
    if (search.isEmpty) {
      if (!desc) {
        return isar.notes.where().sortByCreatedAt().findAll();
      } else {
        return isar.notes.where().sortByCreatedAtDesc().findAll();
      }
    } else {
      final filter = isar.notes
          .filter()
          .titleContains(search, caseSensitive: false)
          .or()
          .contentContains(search, caseSensitive: false);

      if (!desc) {
        return filter.sortByCreatedAt().findAll();
      } else {
        return filter.sortByCreatedAtDesc().findAll();
      }
    }
  }

  @override
  Future<NoteDto?> get(int id) => isar.notes.get(id);

  @override
  Future<void> save(NoteDto entity) => isar.writeTxn(() async {
    await isar.notes.put(entity);
  });

  @override
  Future<void> remove(int id) => isar.writeTxn(() async {
    await isar.notes.delete(id);
  });
}
