import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'authentication_service.dart';
import 'database.dart';

class UserService {
  static final CollectionReference collectionInstance = FirebaseFirestore.instance.collection("users");

  static DocumentReference currentUserDocument(final BuildContext context) {
    return UserService.collectionInstance.doc(context.read<AuthenticationService>().currentUser!.uid);
  }

  static create(final String userId, final String username, final String email) {
    Map<String, Object> data = {"username": username, "email": email};

    DatabaseService.create(id: userId, data: data, collection: collectionInstance);
  }

  static delete(final String userId) {
    DatabaseService.delete(userId, collectionInstance);
  }
}
