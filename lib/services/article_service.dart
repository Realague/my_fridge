import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_fridge/model/category.dart';
import 'package:my_fridge/model/item.dart';
import 'package:my_fridge/services/database.dart';

class ArticleService {
  static final CollectionReference collectionInstance = FirebaseFirestore.instance.collection('articles');

  static create(Item article) {
    collectionInstance.doc(article.name).get().then((DocumentSnapshot documentSnapshot) {
      if (!documentSnapshot.exists) {
        DatabaseService.createWithId(article.name, article.asMap, collectionInstance);
      }
    });
  }

  static update(Item article) {
    DatabaseService.update(article.id!, article.asMap, collectionInstance);
  }

  static delete(String articleId) {
    DatabaseService.delete(articleId, collectionInstance);
  }

  static Future<List<Item>> get(String? searchFilter) async {
    List<Item> articles = [];
    if (searchFilter == null || searchFilter == '') {
      return collectionInstance.get().then((querySnapshot) {
        querySnapshot.docs.forEach((document) => articles.add(Item.fromDocument(document)));
        return articles;
      });
    }
    return collectionInstance
        .where('name', isGreaterThanOrEqualTo: searchFilter)
        .where('name', isLessThan: searchFilter)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((document) => articles.add(Item.fromDocument(document)));
      return articles;
    });
  }

  static Query getByCategory(BuildContext context, final Category category) {
    return collectionInstance.where('category', isEqualTo: category.category);
  }
}
