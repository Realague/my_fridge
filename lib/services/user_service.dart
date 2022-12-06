import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/user.dart';
import 'authentication_service.dart';
import 'database.dart';

class UserService {
  static final CollectionReference collectionInstance = FirebaseFirestore.instance.collection("users");

  static DocumentReference currentUserDocument(final BuildContext context) {
    return UserService.collectionInstance.doc(context.read<AuthenticationService>().currentGoogleUser!.uid);
  }

  static String currentUserId(final BuildContext context) {
    return context.read<AuthenticationService>().currentGoogleUser!.uid;
  }

  static create(final MyFridgeUser user, final BuildContext context) {
    DatabaseService.createWithId(user.id!, user.asMap(context), collectionInstance);
  }

  static MyFridgeUser? getCurrentUserFromCache(final BuildContext context) {
    return context.read<AuthenticationService>().currentUser;
  }

  static Query getHouseholdUsers(final BuildContext context, final String householdId) {
    return collectionInstance.where('householdsId', arrayContains: householdId);
  }

  static void setCurrentUserFromCache(final BuildContext context, final MyFridgeUser user) {
    context.read<AuthenticationService>().currentUser = user;
  }

  static Future<MyFridgeUser?> getCurrentUser(final BuildContext context) {
    return UserService.collectionInstance.doc(context.read<AuthenticationService>().currentGoogleUser!.uid).get().then((documentSnapshot) {
      return MyFridgeUser.fromDocument(documentSnapshot);
    });
  }

  static update(final MyFridgeUser user, final BuildContext context) {
    var data = user.asMap(context);

    DatabaseService.update(user.id!, data, collectionInstance);
  }

  static updateUserHouseholds(BuildContext context, String householdId) {
    MyFridgeUser user = UserService.getCurrentUserFromCache(context)!;
    user.householdsId.add(householdId);
    user.selectedHouseholdId = householdId;
    update(user, context);
  }

  static delete(final String userId) {
    DatabaseService.delete(userId, collectionInstance);
  }
}
