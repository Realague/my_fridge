import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_fridge/model/household.dart';
import 'package:my_fridge/model/storage.dart';
import 'package:my_fridge/services/user_service.dart';

import '../model/user.dart';
import 'database.dart';

class HouseholdService {
  static final CollectionReference collectionInstance = FirebaseFirestore.instance.collection('households');

  static DocumentReference<Object?> getSelectedHouseholdDoc(final BuildContext context) {
    MyFridgeUser user = UserService.getCurrentUserFromCache(context)!;
    return collectionInstance.doc(user.selectedHouseholdId);
  }

  static Future<Household> getSelectedHousehold(final BuildContext context) async {
    MyFridgeUser user = UserService.getCurrentUserFromCache(context)!;
    DocumentSnapshot documentSnapshot = await collectionInstance.doc(user.selectedHouseholdId).get();
    return Household.fromDocument(documentSnapshot);
  }

  static create(final Household household, final BuildContext context) async {
    MyFridgeUser user = UserService.getCurrentUserFromCache(context)!;
    household.createdBy = user.id;
    household.membersId = [user.id!];
    household.availableStoragesType.add(Storage.NONE.index);
    DocumentReference docRef = await DatabaseService.create(household.asMap, collectionInstance);
    UserService.updateUserHouseholds(context, docRef.id);
  }

  static update(final Household household, final BuildContext context) {
    DatabaseService.update(household.id!, household.asMap, collectionInstance);
  }

  static delete(BuildContext context, final String householdId) {
    DatabaseService.delete(householdId, collectionInstance);
    UserService.removeHouseholdFromUser(context, householdId);
  }

  static Query getUserHouseholds(final BuildContext context) {
    return collectionInstance.where('membersId', arrayContains: UserService.getCurrentUserFromCache(context)!.id!);
  }

  static joinHousehold(final BuildContext context, final String householdId) async {
    String userId = UserService.getCurrentUserFromCache(context)!.id!;
    collectionInstance.doc(householdId).update({
      "membersId": FieldValue.arrayUnion([userId])
    });
    UserService.updateUserHouseholds(context, householdId);
  }
}
