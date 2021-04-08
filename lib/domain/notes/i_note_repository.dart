import 'package:dartz/dartz.dart';
import 'package:kt_dart/kt.dart';

import 'note_entity.dart';
import 'note_failure.dart';

abstract class INoteRepository {
  Stream<Either<NoteFailure, KtList<NoteEntity>>> watchAll();
  Stream<Either<NoteFailure, KtList<NoteEntity>>> watchUncompleted();
  Future<Either<NoteFailure, Unit>> create(NoteEntity note);
  Future<Either<NoteFailure, Unit>> update(NoteEntity note);
  Future<Either<NoteFailure, Unit>> delete(NoteEntity note);
}
