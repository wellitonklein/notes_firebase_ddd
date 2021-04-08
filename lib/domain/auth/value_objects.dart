import 'package:dartz/dartz.dart';

import '../core/core.dart';

class EmailAddress extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;
  factory EmailAddress({required String input}) {
    return EmailAddress._(value: validateEmailAddress(input));
  }
  const EmailAddress._({required this.value});
}

class Password extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;
  factory Password({required String input}) {
    return Password._(value: validatePassword(input));
  }
  const Password._({required this.value});
}
