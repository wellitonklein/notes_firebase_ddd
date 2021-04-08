import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kt_dart/kt.dart';

import '../../../../application/application.dart';
import '../../../../domain/domain.dart';

class NoteCardWidget extends StatelessWidget {
  final NoteEntity note;
  const NoteCardWidget({required this.note});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: note.color.getOrCrash(),
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
      child: InkWell(
        onTap: () {
          // TODO: Implement navigation
        },
        onLongPress: () {
          final noteActorBloc = context.read<NoteActorBloc>();
          _showDeletionDialog(context, noteActorBloc);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                note.body.getOrCrash(),
                style: const TextStyle(
                  fontSize: 18.0,
                ),
              ),
              if (note.todos.length > 0) ...[
                const SizedBox(height: 4.0),
                Wrap(
                  spacing: 8,
                  children: [
                    ...note.todos
                        .getOrCrash()
                        .map((todo) => TodoDisplayWidget(todo: todo))
                        .iter,
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showDeletionDialog(BuildContext context, NoteActorBloc noteActorBloc) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Note selecionada:'),
          content: Text(
            note.body.getOrCrash(),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('CANCELAR'),
            ),
            TextButton(
              onPressed: () {
                noteActorBloc.add(NoteActorEvent.deleted(note: note));
                Navigator.pop(context);
              },
              child: const Text('EXCLUIR'),
            ),
          ],
        );
      },
    );
  }
}

class TodoDisplayWidget extends StatelessWidget {
  final TodoItemEntity todo;

  const TodoDisplayWidget({required this.todo});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (todo.done)
          Icon(Icons.check_box, color: Theme.of(context).accentColor)
        else
          Icon(
            Icons.check_box_outline_blank,
            color: Theme.of(context).accentColor,
          ),
        const SizedBox(width: 4.0),
        Text(todo.name.getOrCrash()),
      ],
    );
  }
}
