import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_fridge/model/category.dart';

import 'database.dart';

class CategoryService {
  static final CollectionReference collectionInstance =
      FirebaseFirestore.instance.collection('category');

  static create(final Category category) {
    DatabaseService.create(
        data: category.asMap, collection: collectionInstance);
  }

  static Future<List<Category>> get() {
    List<Category> categories = [];
    return collectionInstance.get().then((querySnapshot) {
      querySnapshot.docs.forEach(
          (document) => categories.add(Category.fromDocument(document)));
      return categories;
    });
  }

  static update(final Category category) {
    DatabaseService.update(category.id!, category.asMap, collectionInstance);
  }

  static delete(final String userId) {
    DatabaseService.delete(userId, collectionInstance);
  }
}
