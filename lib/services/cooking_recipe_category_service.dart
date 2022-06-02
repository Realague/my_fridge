import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_fridge/model/category.dart';

import 'database.dart';

class CookingRecipeCategoryService {
  static final CollectionReference collectionInstance =
      FirebaseFirestore.instance.collection('cooking_recipe_category');

  static create(Category category) {
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

  static update(Category category) {
    DatabaseService.update(category.id!, category.asMap, collectionInstance);
  }

  static delete(String userId) {
    DatabaseService.delete(userId, collectionInstance);
  }
}
