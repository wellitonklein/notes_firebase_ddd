import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kt_dart/kt.dart';

import '../core/core.dart';
import 'todo_item_entity.dart';
import 'value_objects.dart';

part 'note_entity.freezed.dart';

@freezed
abstract class NoteEntity with _$NoteEntity {
  const factory NoteEntity({
    required UniqueId id,
    required NoteBody body,
    required NoteColor color,
    required List3<TodoItemEntity> todos,
  }) = _NoteEntity;

  factory NoteEntity.empty() {
    return NoteEntity(
      id: UniqueId(),
      body: NoteBody(input: ''),
      color: NoteColor(input: NoteColor.predefinedColors.first),
      todos: List3(input: emptyList()),
    );
  }

  const NoteEntity._();

  Option<ValueFailure<dynamic>> get failureOption {
    return body.failureOrUnit
        .andThen(todos.failureOrUnit)
        .andThen(
          todos
              .getOrCrash()
              .map((todoItem) => todoItem.failureOption)
              .filter((o) => o.isSome())
              .getOrElse(0, (_) => none())
              .fold(() => right(unit), (f) => left(f)),
        )
        .fold((f) => some(f), (_) => none());
  }
}
