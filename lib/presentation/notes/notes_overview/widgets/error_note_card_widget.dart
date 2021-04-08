import 'package:flutter/material.dart';

import '../../../../domain/domain.dart';

class ErrorNoteCardWidget extends StatelessWidget {
  final NoteEntity note;
  const ErrorNoteCardWidget({required this.note});

  @override
  Widget build(BuildContext context) {
    final _bodyText2 = Theme.of(context).primaryTextTheme.bodyText2!;

    return Card(
      color: Theme.of(context).errorColor,
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          children: [
            Text(
              'Nota inválida, por favor entrar em contato com suporte',
              style: _bodyText2.copyWith(fontSize: 18.0),
            ),
            const SizedBox(height: 2.0),
            Text('Para nerds:', style: _bodyText2),
            Text(
              note.failureOption.fold(() => '', (f) => f.toString()),
              style: _bodyText2,
            ),
          ],
        ),
      ),
    );
  }
}
