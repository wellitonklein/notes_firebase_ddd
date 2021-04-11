import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../application/application.dart';
import '../../../../domain/domain.dart';

class BodyFieldWidget extends HookWidget {
  const BodyFieldWidget();

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();

    return BlocListener<NoteFormBloc, NoteFormState>(
      listenWhen: (p, c) => p.isEditing != c.isEditing,
      listener: (context, state) {
        controller.text = state.note.body.getOrCrash();
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: TextFormField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Nota',
          ),
          maxLength: NoteBody.maxLength,
          maxLines: null,
          minLines: 5,
          onChanged: (value) => context.read<NoteFormBloc>().add(
                NoteFormEvent.bodyChanged(bodyStr: value),
              ),
          validator: (_) =>
              context.read<NoteFormBloc>().state.note.body.value.fold(
                    (f) => f.maybeMap(
                      empty: (_) => 'Não pode ser vazio',
                      exceedingLength: (f) =>
                          'Excedendo o tamanho máximo de ${f.max}',
                      orElse: () => null,
                    ),
                    (r) => null,
                  ),
        ),
      ),
    );
  }
}
