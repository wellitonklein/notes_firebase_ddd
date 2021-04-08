import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kt_dart/kt.dart';

import '../../domain/domain.dart';

part 'note_dtos.g.dart';

@JsonSerializable()
class NoteDTO {
  @JsonKey(ignore: true)
  final String? id;
  final String body;
  final int color;
  final List<TodoItemDTO> todos;

  NoteDTO({
    this.id,
    required this.body,
    required this.color,
    required this.todos,
  });

  factory NoteDTO.fromDomain(NoteEntity note) {
    return NoteDTO(
      id: note.id.getOrCrash(),
      body: note.body.getOrCrash(),
      color: note.color.getOrCrash().value,
      todos: note.todos
          .getOrCrash()
          .map((todoItem) => TodoItemDTO.fromDomain(todoItem))
          .asList(),
    );
  }

  NoteEntity toDomain() {
    return NoteEntity(
      id: id != null ? UniqueId.fromUniqueString(id!) : UniqueId(),
      body: NoteBody(input: body),
      color: NoteColor(input: Color(color)),
      todos: List3(input: todos.map((dto) => dto.toDomain()).toImmutableList()),
    );
  }

  factory NoteDTO.fromJson(Map<String, dynamic> json) {
    return _$NoteDTOFromJson(json);
  }

  factory NoteDTO.fromFirestore(DocumentSnapshot doc) {
    final _doc = doc.data()!;
    _doc['id'] = doc.id;
    return NoteDTO.fromJson(_doc);
  }

  Map<String, dynamic> toJson() {
    return _$NoteDTOToJson(this);
  }
}

@JsonSerializable()
class TodoItemDTO {
  final String id;
  final String name;
  final bool done;

  TodoItemDTO({
    required this.id,
    required this.name,
    required this.done,
  });

  factory TodoItemDTO.fromDomain(TodoItemEntity todoItem) {
    return TodoItemDTO(
      id: todoItem.id.getOrCrash(),
      name: todoItem.name.getOrCrash(),
      done: todoItem.done,
    );
  }

  TodoItemEntity toDomain() {
    return TodoItemEntity(
      id: UniqueId.fromUniqueString(id),
      name: TodoName(input: name),
      done: done,
    );
  }

  factory TodoItemDTO.fromJson(Map<String, dynamic> json) {
    return _$TodoItemDTOFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$TodoItemDTOToJson(this);
  }
}
