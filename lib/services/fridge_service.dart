import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_fridge/model/category.dart';
import 'package:my_fridge/model/fridge_article.dart';
import 'package:my_fridge/model/shopping_article.dart';
import 'package:my_fridge/services/user_service.dart';

import 'database.dart';

class FridgeService {
  static create(FridgeArticle article, BuildContext context) async {
    if (article.perishable) {
      DatabaseService.create(data: article.asMap, collection: getCollectionInstance(context));
    } else {
      FridgeArticle? existingArticle = await getByArticle(article, context);
      if (existingArticle != null) {
        existingArticle.quantity += article.quantity;
        update(existingArticle, context);
      } else {
        DatabaseService.create(data: article.asMap, collection: getCollectionInstance(context));
      }
    }
  }

  static createFromShoppingArticle(ShoppingArticle article, BuildContext context, {DateTime? expiryDate}) {
    Map<String, Object?> map = {
      'name': article.name,
      'unit': article.unit,
      'quantity': article.quantity,
      'perishable': article.perishable,
      'category': article.category,
      'expiry_date': expiryDate
    };
    DatabaseService.create(data: map, collection: getCollectionInstance(context));
  }

  static update(FridgeArticle article, BuildContext context) {
    var data = article.asMap;

    DatabaseService.update(article.id!, data, getCollectionInstance(context));
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
      querySnapshot.docs.forEach((document) => articles.add(FridgeArticle.fromDocument(document)));
      return articles;
    });
  }

  static Future<FridgeArticle?> getByArticle(FridgeArticle article, BuildContext context) {
    return getCollectionInstance(context)
        .where('name', isEqualTo: article.name)
        .where('unit', isEqualTo: article.unit)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.length != 1) {
        return null;
      }
      return FridgeArticle.fromDocument(querySnapshot.docs[0]);
    });
  }

  static Query getByCategory(BuildContext context, Category category) {
    return getCollectionInstance(context).where('category', isEqualTo: category.category);
  }
}
