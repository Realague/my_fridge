import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_fridge/model/category.dart';
import 'package:my_fridge/model/item.dart';
import 'package:my_fridge/services/database.dart';

class ItemService {
  static final CollectionReference collectionInstance = FirebaseFirestore.instance.collection('items');

  static create(Item item) {
    collectionInstance.doc(item.name).get().then((DocumentSnapshot documentSnapshot) {
      if (!documentSnapshot.exists) {
        DatabaseService.createWithId(item.name, item.asMap, collectionInstance);
      }
    });
  }

  static update(Item item) {
    DatabaseService.update(item.id!, item.asMap, collectionInstance);
  }

  static delete(String articleId) {
    DatabaseService.delete(articleId, collectionInstance);
  }

  static Future<List<Item>> get(String? searchFilter) async {
    List<Item> articles = [];

    QuerySnapshot querySnapshot = await collectionInstance.get();
    querySnapshot.docs.forEach((document) => articles.add(Item.fromDocument(document)));
    articles = articles.where((item) {
      if (searchFilter == null || searchFilter == "") {
        return true;
      } else if (item.name.toLowerCase().contains(searchFilter.toLowerCase())) {
        return true;
    }
      return false;
    }).toList();

    return articles;
  }

  static Query getByCategory(BuildContext context, final Category category) {
    return collectionInstance.where('category', isEqualTo: category.category);
  }

  static Future<Item?> getByName(String name) async {
    QuerySnapshot querySnapshot = await collectionInstance.where("name", isEqualTo: name).get();
    if (querySnapshot.size != 0) {
      return Item.fromDocument(querySnapshot.docs[0]);
    }
    return null;
  }
}
