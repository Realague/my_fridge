import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class MyFridgeUser {
  MyFridgeUser(
      {this.id,
      required this.username,
      required this.email,
      this.selectedStorage});

  String? id;

  String username;

  String email;

  String? selectedStorage;

  static MyFridgeUser fromDocument(final DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    return MyFridgeUser(
        id: document.id,
        username: data['username'],
        email: data['email'],
        selectedStorage: data['selected_storage']);
  }

  Map<String, Object> asMap(final BuildContext context) {
    return {
      'username': this.username,
      'email': this.email,
      'selectedStorage': this.selectedStorage!
    };
  }
}
