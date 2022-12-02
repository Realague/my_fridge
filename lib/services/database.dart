import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  static Future<DocumentReference> create(
      {String? id,
      required Map<String, Object?> data,
      required CollectionReference collection}) {
    return collection.add(data).catchError((e) {
      print(e.toString());
    });
  }

  static update(
      String id, Map<String, Object?> data, CollectionReference collection) {
    collection.doc(id).update(data).catchError((e) {
      print(e.toString());
    });
  }

  static delete(String id, CollectionReference collection) {
    collection.doc(id).delete().catchError((e) {
      print(e.toString());
    });
  }
}
