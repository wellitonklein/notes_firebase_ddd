import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../domain/domain.dart';

part 'todo_item_presentation_classes.freezed.dart';

@freezed
abstract class TodoItemPrimitive implements _$TodoItemPrimitive {
  const factory TodoItemPrimitive({
    required UniqueId id,
    required String name,
    required bool done,
  }) = _TodoItemPrimitive;
  const TodoItemPrimitive._();

  factory TodoItemPrimitive.empty() {
    return TodoItemPrimitive(
      id: UniqueId(),
      name: '',
      done: false,
    );
  }

  factory TodoItemPrimitive.fromDomain(TodoItemEntity todoItem) {
    return TodoItemPrimitive(
      id: todoItem.id,
      name: todoItem.name.getOrCrash(),
      done: todoItem.done,
    );
  }

  TodoItemEntity toDomain() {
    return TodoItemEntity(
      id: id,
      name: TodoName(input: name),
      done: done,
    );
  }
}
