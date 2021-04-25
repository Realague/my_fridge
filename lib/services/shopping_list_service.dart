import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_fridge/model/shopping_article.dart';
import 'package:my_fridge/services/user_service.dart';

import 'database.dart';

class ShoppingListService {
  static create(ShoppingArticle article, BuildContext context) {
    Map<String, Object> data = {
      "name": article.name,
      "unit": article.unit,
      "quantity": article.quantity,
      "perishable": article.perishable,
      "checked": false,
      "category": article.category
    };

    DatabaseService.create(data: data, collection: getCollectionInstance(context));
  }

  static update(ShoppingArticle article, BuildContext context) {
    Map<String, Object> data = {
      "name": article.name,
      "unit": article.unit,
      "quantity": article.quantity,
      "perishable": article.perishable,
      "checked": article.checked,
      "category": article.category
    };

    DatabaseService.update(article.id!, data, getCollectionInstance(context));
  }

  static CollectionReference getCollectionInstance(BuildContext context) {
    return UserService.currentUserDocument(context).collection("shopping_list");
  }

  static delete(String articleId, BuildContext context) {
    DatabaseService.delete(articleId, getCollectionInstance(context));
  }

  static Future<List<ShoppingArticle>> getOrderBy(String field, BuildContext context) async {
    List<ShoppingArticle> articles = [];
    return getCollectionInstance(context).orderBy(field).get().then((querySnapshot) {
      querySnapshot.docs.forEach((article) {
        articles.add(ShoppingArticle(
            id: article.id,
            name: article.data()['name'],
            unit: article.data()['unit'],
            quantity: article.data()['quantity'],
            perishable: article.data()['perishable'],
            checked: article.data()['checked'],
            category: article.data()['category']));
      });
      return articles;
    });
  }
}
