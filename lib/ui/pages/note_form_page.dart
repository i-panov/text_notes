import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:text_notes/core/di.dart';
import 'package:text_notes/domain/models/note.dart';
import 'package:text_notes/ui/blocs/note_view.dart';

class NoteFormPage extends StatelessWidget {
  final int? noteId;

  const NoteFormPage({super.key, this.noteId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NoteViewCubit(
        noteRepository: getIt(),
        id: noteId,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(noteId == null 
              ? 'Создание заметки' 
              : 'Редактирование заметки',
            ),
        ),
        body: Builder(
          builder: (context) {
            return BlocBuilder<NoteViewCubit, NoteViewState>(
              builder: (context, state) {
                return switch (state) {
                  NoteViewInitial() => const Center(
                      child: CircularProgressIndicator(),
                    ),
                  NoteViewNotFound() => const Center(
                      child: Text('Заметка не найдена'),
                    ),
                  NoteViewPresent(:final note) => _NoteForm(note: note),
                };
              },
            );
          },
        ),
      ),
    );
  }
}

class _NoteForm extends StatefulWidget {
  final NoteEntity note;

  const _NoteForm({required this.note});

  @override
  State<_NoteForm> createState() => _NoteFormState();
}

class _NoteFormState extends State<_NoteForm> {
  final _formKey = GlobalKey<FormState>();
  late final _titleCtrl = TextEditingController(text: widget.note.title);
  late final _contentCtrl = TextEditingController(text: widget.note.content);

  @override
  void dispose() {
    _titleCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NoteViewCubit, NoteViewState>(
      listener: (context, state) {
        if (state is NoteViewPresent && state.isSaved) {
          Navigator.pop(context, true);
        }
      },
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _titleCtrl,
                decoration: const InputDecoration(labelText: 'Название'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите название заметки';
                  }
                  
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _contentCtrl,
                decoration: const InputDecoration(labelText: 'Текст'),
                maxLines: 15,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                child: const Text('Сохранить'),
                onPressed: () {
                  if (!_formKey.currentState!.validate()) {
                    return;
                  }

                  context.read<NoteViewCubit>().save(
                    title: _titleCtrl.text,
                    content: _contentCtrl.text,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
