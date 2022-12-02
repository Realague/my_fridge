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
        .doc(context.read<AuthenticationService>().currentGoogleUser!.uid);
  }

  static String currentUserId(final BuildContext context) {
    return context.read<AuthenticationService>().currentGoogleUser!.uid;
  }

  static create(final MyFridgeUser user, final BuildContext context) {
    DatabaseService.create(
        id: user.id, data: user.asMap(context), collection: collectionInstance);
  }

  static MyFridgeUser? getCurrentUserFromCache(final BuildContext context) {
    return context.read<AuthenticationService>().currentUser;
  }

  static void setCurrentUserFromCache(
      final BuildContext context, final MyFridgeUser user) {
    context.read<AuthenticationService>().currentUser = user;
  }

  static Future<MyFridgeUser?> getCurrentUser(final BuildContext context) {
    return UserService.collectionInstance
        .doc(context.read<AuthenticationService>().currentGoogleUser!.uid)
        .get()
        .then((documentSnapshot) {
      return MyFridgeUser.fromDocument(documentSnapshot);
    });
  }

  static update(final MyFridgeUser user, final BuildContext context) {
    var data = user.asMap(context);

    DatabaseService.update(user.id!, data, collectionInstance);
  }

  static delete(final String userId) {
    DatabaseService.delete(userId, collectionInstance);
  }
}
