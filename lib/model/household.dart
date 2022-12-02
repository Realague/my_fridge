import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Household {
  Household(
      {this.id,
      required this.name,
      required this.members,
      required this.availableStorage,
      this.createdBy});

  String? id;

  String name;

  List<String> members;

  List<int> availableStorage;

  String? createdBy;

  static Household fromDocument(final DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    return Household(
        id: document.id,
        name: data['name'],
        members: data['members'],
        availableStorage: data['available_storage'],
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
