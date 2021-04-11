import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kt_dart/kt.dart';

import '../../domain/domain.dart';

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
      id: UniqueId.fromUniqueString(id!),
      body: NoteBody(input: body),
      color: NoteColor(input: Color(color)),
      todos: List3(input: todos.map((dto) => dto.toDomain()).toImmutableList()),
    );
  }

  factory NoteDTO.fromJson(Map<String, dynamic> json) {
    final _note = NoteDTO(
      id: json['id'] as String,
      body: json['body'] as String,
      color: json['color'] as int,
      todos: (json['todos'] as List)
          .map((e) => TodoItemDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

    return _note;
  }

  factory NoteDTO.fromFirestore(DocumentSnapshot doc) {
    final _doc = doc.data()!;
    _doc['id'] = doc.id;
    return NoteDTO.fromJson(_doc);
  }

  Map<String, dynamic> toJson() {
    return {
      'body': body,
      'color': color,
      'todos': todos.map((todoItem) => todoItem.toJson()).toList()
    };
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
    return TodoItemDTO(
      id: json['id'] as String,
      name: json['name'] as String,
      done: json['done'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'done': done,
    };
  }
}
