import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_fridge/model/category.dart';
import 'package:my_fridge/model/packing_type.dart';
import 'package:my_fridge/model/shopping_item.dart';
import 'package:my_fridge/services/shopping_list_service.dart';

import 'database.dart';

class CategoryService {
  static final CollectionReference collectionInstance = FirebaseFirestore.instance.collection('category');

  static create(final Category category) {
    DatabaseService.create(category.asMap, collectionInstance);
  }

  static Future<List<Category>> get() {
    List<Category> categories = [];
    return collectionInstance.get().then((querySnapshot) {
      querySnapshot.docs.forEach((document) => categories.add(Category.fromDocument(document)));
      return categories;
    });
  }

  static update(final Category category) {
    DatabaseService.update(category.id!, category.asMap, collectionInstance);
  }

  static delete(final String userId) {
    DatabaseService.delete(userId, collectionInstance);
  }

  static Future<String> generateShoppingNotes(BuildContext context) async {
    List<Category> categories = await CategoryService.get();

    StringBuffer shoppingListNoteBuffer = StringBuffer();

    for (Category category in categories) {
      List<ShoppingItem> shoppingItems = await ShoppingListService.getByCategory(context, category, false);

      if (shoppingItems.isNotEmpty) {
        shoppingListNoteBuffer.writeAll(["\n", category.category]);
      } else {
        shoppingListNoteBuffer.write("\n");
      }

      for (ShoppingItem shoppingItem in shoppingItems) {
        shoppingListNoteBuffer.writeAll(["\n", shoppingItem.name, shoppingItem.quantity, shoppingItem.packingType.displayText(context), shoppingItem.note], ' ');
      }
    }

    return shoppingListNoteBuffer.toString();
  }
}