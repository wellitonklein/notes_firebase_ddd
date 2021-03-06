import 'package:freezed_annotation/freezed_annotation.dart';

import '../core/core.dart';

part 'user_entity.freezed.dart';

@freezed
class UserEntity with _$UserEntity {
  const factory UserEntity({
    required UniqueId id,
  }) = _UserEntity;
}
