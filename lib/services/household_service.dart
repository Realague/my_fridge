import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_fridge/model/household.dart';
import 'package:my_fridge/services/user_service.dart';

import '../model/user.dart';
import 'database.dart';

class HouseholdService {
  static final CollectionReference collectionInstance = FirebaseFirestore.instance.collection('households');

  static DocumentReference<Object?> getSelectedHousehold(final BuildContext context) {
    MyFridgeUser user = UserService.getCurrentUserFromCache(context)!;
    return collectionInstance.doc(user.selectedStorage);
  }

  static create(final Household household, final BuildContext context) async {
    MyFridgeUser user = UserService.getCurrentUserFromCache(context)!;
    Map<String, Object?> data = household.asMap(context);
    data['created_by'] = user.id;
    data['members'] = [user.id];
    DocumentReference docRef = await DatabaseService.create(data: data, collection: collectionInstance);
    UserService.updateUserHouseholds(context, docRef.id);
  }

  static update(final Household household, final BuildContext context) {
    var data = household.asMap(context);

    DatabaseService.update(household.id!, data, collectionInstance);
  }

  static delete(final String householdId) {
    DatabaseService.delete(householdId, collectionInstance);
  }

  static Query getUserHouseholds(final BuildContext context) {
    return collectionInstance.where('members', arrayContains: UserService.getCurrentUserFromCache(context)!.id!);
  }

  static joinHousehold(final BuildContext context, final String householdId) async {
    Household household = await collectionInstance.doc(householdId).get().then((documentSnapshot) {
      return Household.fromDocument(documentSnapshot);
    });
    DatabaseService.update(household.id!, household.asMap(context), collectionInstance);
    UserService.updateUserHouseholds(context, householdId);
  }
}
