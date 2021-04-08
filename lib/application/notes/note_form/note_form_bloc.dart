import 'dart:async';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/kt.dart';

import '../../../domain/domain.dart';
import '../../../presentation/presentation.dart';

part 'note_form_bloc.freezed.dart';
part 'note_form_event.dart';
part 'note_form_state.dart';

@injectable
class NoteFormBloc extends Bloc<NoteFormEvent, NoteFormState> {
  final INoteRepository _noteRepository;
  NoteFormBloc({required INoteRepository noteRepository})
      : _noteRepository = noteRepository,
        super(NoteFormState.initial());

  @override
  Stream<NoteFormState> mapEventToState(
    NoteFormEvent event,
  ) async* {
    yield* event.map(
      initialized: (e) async* {
        yield e.initialNoteOption.fold(
          () => state,
          (initialNote) => state.copyWith(note: initialNote, isEditing: true),
        );
      },
      bodyChanged: (e) async* {
        yield state.copyWith(
          note: state.note.copyWith(body: NoteBody(input: e.bodyStr)),
          saveFailureOrSuccessOption: none(),
        );
      },
      colorChanged: (e) async* {
        yield state.copyWith(
          note: state.note.copyWith(color: NoteColor(input: e.color)),
          saveFailureOrSuccessOption: none(),
        );
      },
      todosChanged: (e) async* {
        yield state.copyWith(
          note: state.note.copyWith(
            todos: List3(
              input: e.todos.map((primitive) => primitive.toDomain()),
            ),
          ),
          saveFailureOrSuccessOption: none(),
        );
      },
      saved: (e) async* {
        Either<NoteFailure, Unit> failureOrSuccess =
            left(const NoteFailure.unexpected());

        yield state.copyWith(
          isSaving: true,
          saveFailureOrSuccessOption: none(),
        );
        if (state.note.failureOption.isNone()) {
          failureOrSuccess = state.isEditing
              ? await _noteRepository.update(state.note)
              : await _noteRepository.create(state.note);
        }
        yield state.copyWith(
          isSaving: true,
          saveFailureOrSuccessOption: optionOf(failureOrSuccess),
        );
      },
    );
  }
}
