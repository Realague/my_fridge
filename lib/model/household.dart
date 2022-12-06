import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Household {
  Household({this.id, required this.name, required this.membersId, required this.availableStorage, this.createdBy});

  String? id;

  String name;

  List<String> membersId;

  List<int> availableStorage;

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

  static Household fromDocument(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    return Household(
        id: document.id,
        name: data['name'],
        membersId: List.from(data['membersId']),
        availableStorage: List.from(data['availableStorage']),
        createdBy: data['createdBy']);
  }

  Map<String, Object?> asMap(final BuildContext context) {
    return {
      'name': this.name,
      'membersId': this.membersId,
      'availableStorage': this.availableStorage,
      'createdBy': this.createdBy,
    };
  }
}
