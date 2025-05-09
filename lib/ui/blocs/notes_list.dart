import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:text_notes/domain/models/note.dart';
import 'package:text_notes/domain/repositories/notes_repository.dart';

class NotesListCubit extends Cubit<NotesListState> {
  final NotesRepository noteRepository;

  NotesListCubit({
    required this.noteRepository,
  }) : super(const NotesListState(isLoading: true)) {
    load();
  }

  Future<void> load({
    NotesListSort? sort,
    String? query,
  }) async {
    emit(NotesListState(
      isLoading: true,
      sort: sort ?? state.sort,
      query: (query?.isNotEmpty ?? false) ? query! : state.query,
    ));

    final notes = await noteRepository.getAll(
      desc: state.sort.desc,
      search: state.query,
    );

    emit(NotesListState(
      notes: notes.map((n) => n.toEntity()).toIList(),
      isLoading: false,
      sort: state.sort,
    ));
  }

  Future<void> remove(int id) async {
    await noteRepository.remove(id);
    await load();
  }

  Future<void> search(String query) => load(query: query);

  Future<void> sort(NotesListSort sort) => load(sort: sort);

  Future<void> toggleSortByCreatedAt() {
    return sort(NotesListSort(
      desc: state.sort.field == NoteNoteFields.createdAt
          ? !state.sort.desc
          : false,
      field: NoteNoteFields.createdAt,
    ));
  }
}

class NotesListState extends Equatable {
  final IList<NoteEntity> notes;
  final bool isLoading;
  final NotesListSort sort;
  final String query;

  const NotesListState({
    this.notes = const IList.empty(),
    this.isLoading = false,
    this.sort = NotesListSort.defaultSort,
    this.query = '',
  });

  @override
  List<Object?> get props => [notes, isLoading, sort, query];
}

class NotesListSort extends Equatable {
  static const defaultSort = NotesListSort(
    desc: false,
    field: NoteNoteFields.createdAt,
  );

  final bool desc;

  // сейчас не используется, потому что только одно поле сортировки
  final NoteNoteFields field;

  const NotesListSort({
    required this.desc,
    required this.field,
  });

  @override
  List<Object?> get props => [desc, field];
}

typedef NotesList = IList<NoteEntity>;

enum NoteNoteFields {
  createdAt,
}
