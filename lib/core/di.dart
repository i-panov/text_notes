import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:text_notes/data/dto/note/note.dart';
import 'package:text_notes/data/repositories/notes_repository.dart';
import 'package:text_notes/domain/repositories/notes_repository.dart';
import 'package:text_notes/ui/blocs/notes_list.dart';
import 'package:text_notes/ui/providers/theme_mode_provider.dart';

final getIt = GetIt.instance;

Future<void> setupDi() async {
  final dir = await getApplicationDocumentsDirectory();

  final isar = await Isar.open(
    [NoteDtoSchema],
    directory: dir.path,
  );

  getIt.registerSingleton(isar);

  getIt.registerSingleton<NotesRepository>(NotesRepositoryImpl(
    isar: isar,
  ));

  getIt.registerSingleton(NotesListCubit(noteRepository: getIt()));
  getIt.registerSingleton(ThemeModeProvider());
}
