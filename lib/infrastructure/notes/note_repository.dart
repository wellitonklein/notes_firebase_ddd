import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/kt.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/domain.dart';
import '../core/core.dart';
import 'note_dtos.dart';

@LazySingleton(as: INoteRepository)
class NoteRepository implements INoteRepository {
  final FirebaseFirestore _firestore;
  const NoteRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  @override
  Stream<Either<NoteFailure, KtList<NoteEntity>>> watchAll() async* {
    final userDoc = await _firestore.userDocument();
    yield* userDoc.noteCollection
        .snapshots()
        .map(
          (snapshot) => right<NoteFailure, KtList<NoteEntity>>(
            snapshot.docs
                .map((doc) => NoteDTO.fromFirestore(doc).toDomain())
                .toImmutableList(),
          ),
        )
        .onErrorReturnWith(
      (error) {
        if (error is PlatformException &&
            error.message!.contains('PERMISSION_DENIED')) {
          return left(const NoteFailure.insufficientPermission());
        } else {
          return left(const NoteFailure.unexpected());
        }
      },
    );
  }

  @override
  Stream<Either<NoteFailure, KtList<NoteEntity>>> watchUncompleted() async* {
    final userDoc = await _firestore.userDocument();
    yield* userDoc.noteCollection
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => NoteDTO.fromFirestore(doc).toDomain()),
        )
        .map(
          (notes) => right<NoteFailure, KtList<NoteEntity>>(
            notes
                .where((note) =>
                    note.todos.getOrCrash().any((todoItem) => !todoItem.done))
                .toImmutableList(),
          ),
        )
        .onErrorReturnWith(
      (error) {
        if (error is PlatformException &&
            error.message!.contains('PERMISSION_DENIED')) {
          return left(const NoteFailure.insufficientPermission());
        } else {
          return left(const NoteFailure.unexpected());
        }
      },
    );
  }

  @override
  Future<Either<NoteFailure, Unit>> create(NoteEntity note) async {
    try {
      final userDoc = await _firestore.userDocument();
      final noteDTO = NoteDTO.fromDomain(note);
      await userDoc.noteCollection.doc(noteDTO.id).set(noteDTO.toJson());
      return right(unit);
    } on PlatformException catch (error) {
      if (error.message!.contains('PERMISSION_DENIED')) {
        return left(const NoteFailure.insufficientPermission());
      } else {
        return left(const NoteFailure.unexpected());
      }
    }
  }

  @override
  Future<Either<NoteFailure, Unit>> update(NoteEntity note) async {
    try {
      final userDoc = await _firestore.userDocument();
      final noteDTO = NoteDTO.fromDomain(note);
      await userDoc.noteCollection.doc(noteDTO.id).update(noteDTO.toJson());
      return right(unit);
    } on PlatformException catch (error) {
      if (error.message!.contains('PERMISSION_DENIED')) {
        return left(const NoteFailure.insufficientPermission());
      } else if (error.message!.contains('NOTE_FOUND')) {
        return left(const NoteFailure.unableToUpdate());
      } else {
        return left(const NoteFailure.unexpected());
      }
    }
  }

  @override
  Future<Either<NoteFailure, Unit>> delete(NoteEntity note) async {
    try {
      final userDoc = await _firestore.userDocument();
      final noteId = note.id.getOrCrash();
      await userDoc.noteCollection.doc(noteId).delete();
      return right(unit);
    } on PlatformException catch (error) {
      if (error.message!.contains('PERMISSION_DENIED')) {
        return left(const NoteFailure.insufficientPermission());
      } else if (error.message!.contains('NOTE_FOUND')) {
        return left(const NoteFailure.unableToUpdate());
      } else {
        return left(const NoteFailure.unexpected());
      }
    }
  }
}
