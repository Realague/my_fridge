import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_fridge/model/household.dart';
import 'package:my_fridge/services/user_service.dart';

import 'database.dart';

class HouseholdService {
  static final CollectionReference collectionInstance =
      FirebaseFirestore.instance.collection('households');

  static DocumentReference<Object?> getSelectedHousehold(
      final BuildContext context) {
    return collectionInstance
        .doc(UserService.getCurrentUser(context).selectedStorage!);
  }

  static create(final Household household, final BuildContext context) async {
    DatabaseService.create(
        data: household.asMap(context), collection: collectionInstance);
  }

  static update(final Household household, final BuildContext context) {
    var data = household.asMap(context);

    DatabaseService.update(household.id!, data, collectionInstance);
  }

  static delete(final String householdId) {
    DatabaseService.delete(householdId, collectionInstance);
  }

  static Future<List<Household>> getUserHouseholds(final BuildContext context) {
    List<Household> households = [];
    return collectionInstance
        .where('members', arrayContains: UserService.getCurrentUser(context).id)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach(
          (document) => households.add(Household.fromDocument(document)));
      return households;
    });
  }
}
