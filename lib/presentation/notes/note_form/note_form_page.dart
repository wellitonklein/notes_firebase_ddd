import 'package:another_flushbar/flushbar_helper.dart';
import 'package:auto_route/auto_route.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../application/application.dart';
import '../../../domain/domain.dart';
import '../../../injection.dart';
import '../../routes/router.gr.dart';
import 'misc/misc.dart';
import 'widgets/widgets.dart';

class NoteFormPage extends StatelessWidget {
  final NoteEntity? editedNote;
  const NoteFormPage({required this.editedNote});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NoteFormBloc>(
      create: (context) => getIt<NoteFormBloc>()
        ..add(
          NoteFormEvent.initialized(initialNoteOption: optionOf(editedNote)),
        ),
      child: BlocConsumer<NoteFormBloc, NoteFormState>(
        listenWhen: (p, c) =>
            p.saveFailureOrSuccessOption != c.saveFailureOrSuccessOption,
        listener: (context, state) {
          state.saveFailureOrSuccessOption.fold(
            () => {},
            (either) {
              either.fold(
                (f) {
                  FlushbarHelper.createError(
                    message: f.map(
                      unexpected: (state) =>
                          'Ocorreu um erro inesperado, entre em contato com o suporte.',
                      unableToUpdate: (state) =>
                          'Não foi possível atualizar a nota. Foi excluído de outro dispositivo?',
                      insufficientPermission: (state) => 'Sem permissão ❌',
                    ),
                  ).show(context);
                },
                (_) => AutoRouter.of(context).popUntil(
                  (route) => route.settings.name == NotesOverviewPageRoute.name,
                ),
              );
            },
          );
        },
        buildWhen: (p, c) => p.isSaving != c.isSaving,
        builder: (context, state) {
          return Stack(
            children: [
              const NoteFormPageScaffold(),
              SavingInProgressOverlay(isSaving: state.isSaving),
            ],
          );
        },
      ),
    );
  }
}

class SavingInProgressOverlay extends StatelessWidget {
  final bool isSaving;
  const SavingInProgressOverlay({required this.isSaving});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !isSaving,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        color: isSaving ? Colors.black.withOpacity(0.8) : Colors.transparent,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Visibility(
          visible: isSaving,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 8.0),
              Text(
                'Salvando',
                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NoteFormPageScaffold extends StatelessWidget {
  const NoteFormPageScaffold({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<NoteFormBloc, NoteFormState>(
          buildWhen: (p, c) => p.isEditing != c.isEditing,
          builder: (context, state) {
            return Text(state.isEditing ? 'Editando Nota' : 'Criando Nota');
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              context.read<NoteFormBloc>().add(const NoteFormEvent.saved());
            },
          ),
        ],
      ),
      body: BlocBuilder<NoteFormBloc, NoteFormState>(
        buildWhen: (p, c) => p.showErrorMessages != c.showErrorMessages,
        builder: (context, state) {
          return ChangeNotifierProvider(
            create: (_) => FormTodos(),
            child: Form(
              autovalidateMode: state.showErrorMessages
                  ? AutovalidateMode.always
                  : AutovalidateMode.disabled,
              child: SingleChildScrollView(
                child: Column(
                  children: const [
                    BodyFieldWidget(),
                    ColorFieldWidget(),
                    TodoListWidget(),
                    AddTodoTileWidget(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
