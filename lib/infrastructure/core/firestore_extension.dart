import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/domain.dart';
import '../../injection.dart';

extension FirestoreExtension on FirebaseFirestore {
  Future<DocumentReference> userDocument() async {
    final userOption = await getIt<IAuthFacade>().getSignedInUser();
    final user = userOption.getOrElse(() => throw NotAuthenticatedError());
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.id.getOrCrash());
  }
}

extension DocumenteReferenceExtension on DocumentReference {
  CollectionReference get noteCollection => collection('notes');
}
