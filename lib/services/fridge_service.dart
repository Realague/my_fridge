import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_fridge/model/fridge_article.dart';
import 'package:my_fridge/services/user_service.dart';

import 'database.dart';

class FridgeService {
  static create(FridgeArticle article, BuildContext context) {
    Map<String, Object> data = {
      "name": article.name,
      "unit": article.unit,
      "quantity": article.quantity,
      "perishable": article.perishable,
      "category": article.category,
      "expiry_date": article.expiryDate
    };

    DatabaseService.create(data: data, collection: getCollectionInstance(context));
  }

  static update(String id, FridgeArticle article, BuildContext context) {
    Map<String, Object> data = {
      "name": article.name,
      "unit": article.unit,
      "quantity": article.quantity,
      "perishable": article.perishable,
      "category": article.category,
      "expiry_date": article.expiryDate
    };

    DatabaseService.update(id, data, getCollectionInstance(context));
  }

  static CollectionReference getCollectionInstance(BuildContext context) {
    return UserService.currentUserDocument(context).collection("fridge");
  }

  static delete(String articleId, BuildContext context) {
    DatabaseService.delete(articleId, getCollectionInstance(context));
  }

  static Future<List<FridgeArticle>> getOrderBy(String field, BuildContext context) async {
    List<FridgeArticle> articles = [];
    return getCollectionInstance(context).orderBy(field).get().then((querySnapshot) {
      querySnapshot.docs.forEach((article) {
        articles.add(FridgeArticle(
            id: article.id,
            name: article.data()['name'],
            unit: article.data()['unit'],
            quantity: article.data()['quantity'],
            perishable: article.data()['perishable'],
            category: article.data()['category'],
            expiryDate: article.data()['expiry_date']));
      });
      return articles;
    });
  }
}
