import 'dart:ui';

import 'package:dartz/dartz.dart';
import 'package:kt_dart/kt.dart';

import '../core/core.dart';

class NoteBody extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  static const maxLength = 1000;

  factory NoteBody({required String input}) {
    return NoteBody._(
      value: validateMaxStringLength(input, maxLength)
          .flatMap(validateStringNotEmpty),
    );
  }

  const NoteBody._({required this.value});
}

class TodoName extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  static const maxLength = 30;

  factory TodoName({required String input}) {
    return TodoName._(
      value: validateMaxStringLength(input, maxLength)
          .flatMap(validateStringNotEmpty)
          .flatMap(validateSingleLine),
    );
  }

  const TodoName._({required this.value});
}

class NoteColor extends ValueObject<Color> {
  static const List<Color> predefinedColors = [
    Color(0xfffafafa), // canvas
    Color(0xfffa8072), // salmon
    Color(0xfffedc56), // mustard
    Color(0xffd0f0c0), // tea
    Color(0xfffca3b7), // flamingo
    Color(0xff997950), // tortilla
    Color(0xfffffdd0), // cream
  ];

  @override
  final Either<ValueFailure<Color>, Color> value;

  factory NoteColor({required Color input}) {
    return NoteColor._(
      value: right(makeColorOpaque(input)),
    );
  }

  const NoteColor._({required this.value});
}

class List3<T> extends ValueObject<KtList<T>> {
  @override
  final Either<ValueFailure<KtList<T>>, KtList<T>> value;

  static const maxLength = 3;

  factory List3({required KtList<T> input}) {
    return List3._(
      value: validateMaxListLength(input, maxLength),
    );
  }

  const List3._({required this.value});

  int get length {
    return value.getOrElse(() => emptyList()).size;
  }

  bool get isFull {
    return length >= maxLength;
  }
}
