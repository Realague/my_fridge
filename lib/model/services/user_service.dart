import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/user.dart';
import 'authentication_service.dart';
import 'database.dart';

class UserService {
  UserService();

  MyFridgeUser? currentUser;

  static final CollectionReference collectionInstance = FirebaseFirestore.instance.collection("users");

  DocumentReference currentUserDocument(BuildContext context) {
    return collectionInstance.doc(this.currentUser!.id);
  }

  static String currentUserId(BuildContext context) {
    return context.read<AuthenticationService>().currentGoogleUser!.uid;
  }

  static create(MyFridgeUser user, BuildContext context) {
    DatabaseService.createWithId(user.id!, user.asMap, collectionInstance);
  }

  static MyFridgeUser getCurrentUser(BuildContext context) {
    return context.read<UserService>().currentUser!;
  }

  static Future<MyFridgeUser> getUserById(BuildContext context, String userId) async {
    DocumentSnapshot documentSnapshot = await collectionInstance.doc(userId).get();
    return MyFridgeUser.fromDocument(documentSnapshot);
  }

  static Query getHouseholdUsers(BuildContext context, String householdId) {
    return collectionInstance.where('householdsId', arrayContains: householdId);
  }

  static Future<MyFridgeUser> getCurrentUserFromDb(BuildContext context) async {
    DocumentSnapshot documentSnapshot = await collectionInstance.doc(context.read<AuthenticationService>().currentGoogleUser!.uid).get();
    return MyFridgeUser.fromDocument(documentSnapshot);
  }

  static update(MyFridgeUser user, BuildContext context) {
    DatabaseService.update(user.id!, user.asMap, collectionInstance);
  }

  updateUserHouseholds(BuildContext context, String householdId) {
    collectionInstance.doc(currentUser!.id!).update({
      "householdsId": FieldValue.arrayUnion([householdId]),
      "selectedHouseholdId": householdId
    });
  }

  static delete(String userId) {
    DatabaseService.delete(userId, collectionInstance);
  }

  removeHouseholdFromUser(BuildContext context, String householdId) {
    this.currentUserDocument(context).update({
      'householdsId': FieldValue.arrayRemove([householdId])
    });
  }
}
