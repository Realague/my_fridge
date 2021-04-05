import 'package:cloud_firestore/cloud_firestore.dart';

import 'database.dart';

class UserService {

  static final CollectionReference collectionInstance = FirebaseFirestore.instance.collection("users");

  static create(String userId, String username, String email) {
    Map<String, Object> data = {
      "username": username,
      "email": email
    };

    DatabaseService.create(userId, data, collectionInstance);
  }

  static delete(String userId) {
    DatabaseService.delete(userId, collectionInstance);
  }

}