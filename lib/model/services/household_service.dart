import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_fridge/model/household.dart';
import 'package:my_fridge/model/services/database.dart';
import 'package:my_fridge/model/services/user_service.dart';
import 'package:my_fridge/model/storage.dart';
import 'package:my_fridge/model/user.dart';
import 'package:provider/provider.dart';

class HouseholdService {
  Household? currentHousehold;

  static final CollectionReference collectionInstance = FirebaseFirestore.instance.collection('households');

  static DocumentReference<Object?> getSelectedHouseholdDoc(BuildContext context) {
    return collectionInstance.doc(HouseholdService.getSelectedHousehold(context).id);
  }

  static Future<Household> getSelectedHouseholdFromDb(BuildContext context) async {
    MyFridgeUser user = UserService.getCurrentUser(context);
    DocumentSnapshot documentSnapshot = await collectionInstance.doc(user.selectedHouseholdId).get();
    return Household.fromDocument(documentSnapshot);
  }

  static Household getSelectedHousehold(BuildContext context) {
    return context.read<HouseholdService>().currentHousehold!;
  }

  static create(Household household, BuildContext context) async {
    MyFridgeUser user = UserService.getCurrentUser(context);
    household.createdBy = user.id;
    household.membersId = [user.id!];
    if (!household.availableStoragesType.contains(Storage.NONE.index)) {
      household.availableStoragesType.add(Storage.NONE.index);
    }
    DocumentReference docRef = await DatabaseService.create(household.asMap, collectionInstance);
    context.read<UserService>().updateUserHouseholds(context, docRef.id);
  }

  static update(Household household, BuildContext context) {
    if (!household.availableStoragesType.contains(Storage.NONE.index)) {
      household.availableStoragesType.add(Storage.NONE.index);
    }
    DatabaseService.update(household.id!, household.asMap, collectionInstance);
  }

  static delete(BuildContext context, String householdId) {
    DatabaseService.delete(householdId, collectionInstance);
    context.read<UserService>().removeHouseholdFromUser(context, householdId);
  }

  static Query getUserHouseholds(final BuildContext context) {
    return collectionInstance.where('membersId', arrayContains: UserService.getCurrentUser(context).id!);
  }

  static joinHousehold(BuildContext context, String householdId) async {
    String userId = UserService.getCurrentUser(context).id!;
    collectionInstance.doc(householdId).update({
      "membersId": FieldValue.arrayUnion([userId])
    });
    context.read<UserService>().updateUserHouseholds(context, householdId);
  }
}
