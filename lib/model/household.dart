import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Household {
  Household({this.id, required this.name, required this.members, required this.availableStorage, this.createdBy});

  String? id;

  String name;

  List<String> members;

  List<int> availableStorage;

  String? createdBy;

  String getMembersDisplay(final BuildContext context) {
    if (members.length == 1) {
      return AppLocalizations.of(context)!.household_only_member;
    }
    String display = "";
    //members.forEach((member) => display += member);
    return display;
  }

  static Household fromDocument(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    return Household(
        id: document.id,
        name: data['name'],
        members: List.from(data['members']),
        availableStorage: List.from(data['available_storage']),
        createdBy: data['created_by']);
  }

  Map<String, Object?> asMap(final BuildContext context) {
    return {
      'name': this.name,
      'members': this.members,
      'available_storage': this.availableStorage,
      'created_by': this.createdBy,
    };
  }
}
