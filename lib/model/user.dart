import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class MyFridgeUser {
  MyFridgeUser(
      {this.id, required this.username, required this.email, required this.imageUrl, this.selectedHouseholdId, required this.householdsId});

  String? id;

  String username;

  String email;

  String imageUrl;

  String? selectedHouseholdId;

  List<String> householdsId;

  static MyFridgeUser fromDocument(final DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    return MyFridgeUser(
      id: document.id,
      username: data['username'],
      email: data['email'],
      imageUrl: data['imageUrl'],
      selectedHouseholdId: data['selectedHouseholdId'],
      householdsId: List.from(data['householdsId']),
    );
  }

  Map<String, Object?> get asMap {
    return {
      'username': this.username,
      'email': this.email,
      'imageUrl': this.imageUrl,
      'selectedHouseholdId': this.selectedHouseholdId,
      'householdsId': this.householdsId
    };
  }
}
