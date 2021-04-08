part of 'note_form_bloc.dart';

@freezed
class NoteFormState with _$NoteFormState {
  const factory NoteFormState({
    required NoteEntity note,
    required bool showErrorMessages,
    required bool isEditing,
    required bool isSaving,
    required Option<Either<NoteFailure, Unit>> saveFailureOrSuccessOption,
  }) = _NoteFormState;

  factory NoteFormState.initial() {
    return NoteFormState(
      note: NoteEntity.empty(),
      showErrorMessages: false,
      isEditing: false,
      isSaving: false,
      saveFailureOrSuccessOption: none(),
    );
  }
}
