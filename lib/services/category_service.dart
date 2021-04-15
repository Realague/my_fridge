import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_fridge/model/category.dart';

import 'database.dart';

class CategoryService {
  static final CollectionReference collectionInstance = FirebaseFirestore.instance.collection('category');

  static create(String category) {
    Map<String, Object> data = {"category": category};

    DatabaseService.create(data: data, collection: collectionInstance);
  }

  static Future<List<Category>> get() {
    List<Category> categories = [];
    return collectionInstance.get().then((querySnapshot) {
      querySnapshot.docs.forEach((category) {
        categories.add(Category(id: category.id, category: category.data()['category']));
      });
      return categories;
    });
  }

  static delete(String userId) {
    DatabaseService.delete(userId, collectionInstance);
  }
}
