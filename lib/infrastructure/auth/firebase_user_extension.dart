import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/domain.dart';

extension FirebaseUserDomainExtension on User {
  UserEntity toDomain() {
    return UserEntity(
      id: UniqueId.fromUniqueString(uid),
    );
  }
}
