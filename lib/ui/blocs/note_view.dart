import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:text_notes/domain/models/note.dart';
import 'package:text_notes/domain/repositories/notes_repository.dart';

class NoteViewCubit extends Cubit<NoteViewState> {
  final NotesRepository noteRepository;
  final int? id;

  NoteViewCubit({
    required this.noteRepository,
    this.id,
  }) : super(const NoteViewInitial()) {
    if (id == null) {
      emit(NoteViewDefault(note: NoteEntity(
        title: '',
        content: '',
        createdAt: DateTime.now(),
      )));
    } else {
      noteRepository.get(id!).then((note) {
        if (note == null) {
          emit(const NoteViewNotFound());
        } else {
          emit(NoteViewLoaded(note: note.toEntity()));
        }
      });
    }
  }

  void save({
    required String title,
    required String content,
  }) {
    final presentState = state as NoteViewPresent;

    final note = NoteEntity(
      id: id,
      title: title,
      content: content,
      createdAt: DateTime.now(),
    );

    noteRepository.save(note.toDto()).then((_) {
      emit(presentState.toSaved());
    });
  }
}

sealed class NoteViewState extends Equatable {
  const NoteViewState();

  @override
  List<Object?> get props => [];
}

class NoteViewInitial extends NoteViewState {
  const NoteViewInitial();
}

sealed class NoteViewPresent extends NoteViewState {
  final NoteEntity note;
  final bool isSaved;

  const NoteViewPresent({required this.note, this.isSaved = false});

  @override
  List<Object?> get props => [note, isSaved];

  NoteViewPresent toSaved() => switch (this) {
    NoteViewDefault() => NoteViewDefault(note: note, isSaved: true),
    NoteViewLoaded() => NoteViewLoaded(note: note, isSaved: true),
  };
}

class NoteViewDefault extends NoteViewPresent {
  const NoteViewDefault({required super.note, super.isSaved = false});
}

class NoteViewLoaded extends NoteViewPresent {
  const NoteViewLoaded({required super.note, super.isSaved = false});
}

class NoteViewNotFound extends NoteViewState {
  const NoteViewNotFound();
}
