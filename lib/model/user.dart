import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class MyFridgeUser {
  MyFridgeUser(
      {this.id, required this.username, required this.email, required this.imageUrl, this.selectedHousehold, required this.households});

  String? id;

  String username;

  String email;

  String imageUrl;

  String? selectedHousehold;

  List<String> households;

  static MyFridgeUser fromDocument(final DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    return MyFridgeUser(
      id: document.id,
      username: data['username'],
      email: data['email'],
      imageUrl: data['imageUrl'],
      selectedHousehold: data['selectedHousehold'],
      households: List.from(data['households']),
    );
  }

  Map<String, Object?> asMap(final BuildContext context) {
    return {
      'username': this.username,
      'email': this.email,
      'imageUrl': this.imageUrl,
      'selectedHousehold': this.selectedHousehold,
      'households': this.households
    };
  }
}
