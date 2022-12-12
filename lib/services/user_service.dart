import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/user.dart';
import 'authentication_service.dart';
import 'database.dart';

class UserService {
  static final CollectionReference collectionInstance = FirebaseFirestore.instance.collection("users");

  static DocumentReference currentUserDocument(BuildContext context) {
    return UserService.collectionInstance.doc(context.read<AuthenticationService>().currentGoogleUser!.uid);
  }

  static String currentUserId(BuildContext context) {
    return context.read<AuthenticationService>().currentGoogleUser!.uid;
  }

  static create(final MyFridgeUser user, final BuildContext context) {
    DatabaseService.createWithId(user.id!, user.asMap, collectionInstance);
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

  static Future<MyFridgeUser> getCurrentUser(final BuildContext context) async {
    DocumentSnapshot documentSnapshot =
        await UserService.collectionInstance.doc(context.read<AuthenticationService>().currentGoogleUser!.uid).get();
    return MyFridgeUser.fromDocument(documentSnapshot);
  }

  static update(final MyFridgeUser user, final BuildContext context) {
    DatabaseService.update(user.id!, user.asMap, collectionInstance);
  }

  static updateUserHouseholds(BuildContext context, String householdId) {
    String userId = UserService.getCurrentUserFromCache(context)!.id!;
    collectionInstance.doc(userId).update({
      "householdsId": FieldValue.arrayUnion([householdId]),
      "selectedHouseholdId": householdId
    });
  }

  static delete(final String userId) {
    DatabaseService.delete(userId, collectionInstance);
  }

  static removeHouseholdFromUser(BuildContext context, String householdId) {
    currentUserDocument(context).update({
      'householdsId': FieldValue.arrayRemove([householdId])
    });
  }
}
