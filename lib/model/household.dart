import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../model/storage.dart';

class Household {
  Household(
      {this.id,
      required this.name,
      required this.membersId,
      required this.availableStoragesType,
      required this.expiredItemWarningDelay,
      this.createdBy});

  String? id;

  String name;

  List<String> membersId;

  List<int> availableStoragesType;

  int expiredItemWarningDelay;

  String? createdBy;

  String getMembersDisplay(final BuildContext context) {
    if (membersId.length == 1) {
      return AppLocalizations.of(context)!.household_only_member;
    }
    String display = "";
    //TODO fix display multiple members
    //members.forEach((member) => display += member);
    return display;
  }

  setAvailableStoragesType(bool hasFridge, bool hasFreezer, bool hasCellar) {
    if (hasFridge) {
      this.availableStoragesType.add(Storage.FRIDGE.index);
    }
    if (hasFreezer) {
      this.availableStoragesType.add(Storage.FREEZER.index);
    }
    if (hasCellar) {
      this.availableStoragesType.add(Storage.CELLAR.index);
      this.availableStoragesType.add(Storage.CUPBOARD.index);
    }
  }

  static Household fromDocument(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    return Household(
        id: document.id,
        name: data['name'],
        membersId: List.from(data['membersId']),
        availableStoragesType: List.from(data['availableStorageType']),
        expiredItemWarningDelay: data['expiredItemWarningDelay'],
        createdBy: data['createdBy']);
  }

  Map<String, Object?> get asMap {
    return {
      'name': this.name,
      'membersId': this.membersId,
      'availableStorageType': this.availableStoragesType,
      'expiredItemWarningDelay': this.expiredItemWarningDelay,
      'createdBy': this.createdBy,
    };
  }
}
