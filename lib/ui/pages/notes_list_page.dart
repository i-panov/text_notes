import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:text_notes/core/di.dart';
import 'package:text_notes/ui/blocs/notes_list.dart';
import 'package:text_notes/ui/pages/note_form_page.dart';
import 'package:text_notes/ui/providers/theme_mode_provider.dart';

class NotesListPage extends StatefulWidget {
  const NotesListPage({super.key});

  @override
  State<NotesListPage> createState() => _NotesListPageState();
}

class _NotesListPageState extends State<NotesListPage> {
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    final dateFmt = DateFormat('dd.MM.yyyy HH:mm').format;
    final bloc = getIt<NotesListCubit>();

    return Scaffold(
      appBar: AppBar(
        title: !_isSearching ? const Text('Заметки') : TextField(
          decoration: InputDecoration(
            hintText: 'Поиск...',
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: _toggleSearch,
            ),
          ),
          onChanged: (value) {
            bloc.search(value);
          },
        ),
        actions: [
          if (!_isSearching) ...[
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: _toggleSearch,
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () async {
                await bloc.load();
              },
            ),
            IconButton(
              icon: const Icon(Icons.dark_mode),
              onPressed: getIt<ThemeModeProvider>().toggleThemeMode,
            ),
          ],
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: BlocBuilder<NotesListCubit, NotesListState>(
          bloc: bloc,
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state.notes.isEmpty) {
              return const Center(
                child: Text('Нет заметок'),
              );
            }

            final sortIcon =
                state.sort.desc ? Icons.arrow_downward : Icons.arrow_upward;

            final dateLabel = Text('Дата',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            );

            final titleLabel = Text('Заголовок',
              style: TextStyle(fontWeight: FontWeight.bold),
            );

            final contentLabel = Text('Содержание',
              style: TextStyle(fontWeight: FontWeight.bold),
            );

            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: InkWell(
                          onTap: bloc.toggleSortByCreatedAt,
                          child: state.sort.field == NoteNoteFields.createdAt
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  spacing: 5,
                                  children: [
                                    dateLabel,
                                    Icon(sortIcon),
                                  ],
                                )
                              : dateLabel,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Center(
                        child: titleLabel,
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Center(
                        child: contentLabel,
                      ),
                    ),
                  ],
                ),
                const Divider(),
                Expanded(
                  child: GridView(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      childAspectRatio: 5,
                      mainAxisSpacing: 8,
                    ),
                    padding: const EdgeInsets.all(8),
                    children: state.notes.map((note) {
                      return Slidable(
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (_) async {
                                await bloc.remove(note.id!);
                              },
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Удалить',
                            ),
                          ],
                        ),
                        child: InkWell(
                          onTap: () async {
                            final success = await Navigator.push<bool?>(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    NoteFormPage(noteId: note.id),
                              ),
                            );
                            if (success == true && context.mounted) {
                              await bloc.load();
                            }
                          },
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Center(
                                  child: Text(dateFmt(note.createdAt),
                                    style: const TextStyle(
                                        color: Colors.blue, fontSize: 14),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Center(
                                  child: Text(note.title,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Center(
                                  child: Text(note.content,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: IconButton(
        icon: Icon(Icons.add, size: 60, color: Colors.green),
        onPressed: () async {
          final success = await Navigator.push<bool?>(context,
              MaterialPageRoute(
                builder: (context) => NoteFormPage(),
              ));

          if (success == true && context.mounted) {
            await bloc.load();
          }
        },
      ),
    );
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
    });
  }
}
