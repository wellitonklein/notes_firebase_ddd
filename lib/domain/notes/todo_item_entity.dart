import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../core/core.dart';
import 'value_objects.dart';

part 'todo_item_entity.freezed.dart';

@freezed
abstract class TodoItemEntity implements _$TodoItemEntity {
  const factory TodoItemEntity({
    required UniqueId id,
    required TodoName name,
    required bool done,
  }) = _TodoItemEntity;

  factory TodoItemEntity.empty() {
    return TodoItemEntity(
      id: UniqueId(),
      name: TodoName(input: ''),
      done: false,
    );
  }

  const TodoItemEntity._();

  Option<ValueFailure<dynamic>> get failureOption {
    return name.value.fold((f) => some(f), (r) => none());
  }
}
