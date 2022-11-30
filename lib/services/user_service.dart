import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/user.dart';
import 'authentication_service.dart';
import 'database.dart';

class UserService {
  static final CollectionReference collectionInstance =
      FirebaseFirestore.instance.collection("users");

  static DocumentReference currentUserDocument(final BuildContext context) {
    return UserService.collectionInstance
        .doc(context.read<AuthenticationService>().currentUser!.uid);
  }

  static create(final MyFridgeUser user, final BuildContext context) {
    DatabaseService.create(
        id: user.id, data: user.asMap(context), collection: collectionInstance);
  }

  static MyFridgeUser getCurrentUser(final BuildContext context) {
    MyFridgeUser user = MyFridgeUser(username: '', email: '');
    UserService.collectionInstance
        .doc(context.read<AuthenticationService>().currentUser!.uid)
        .get()
        .then((documentSnapshot) {
      user = MyFridgeUser.fromDocument(documentSnapshot);
    });
    return user;
  }

  static delete(final String userId) {
    DatabaseService.delete(userId, collectionInstance);
  }
}
