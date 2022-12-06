import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_fridge/model/category.dart';
import 'package:my_fridge/model/shopping_article.dart';
import 'package:my_fridge/services/household_service.dart';

import 'database.dart';

class ShoppingListService {
  static create(final ShoppingArticle article, final BuildContext context) {
    DatabaseService.create(article.asMap, getCollectionInstance(context));
  }

  static createFromFridge(final ShoppingArticle article, final BuildContext context) {
    DatabaseService.create(article.asMap, getCollectionInstance(context));
  }

  static update(final ShoppingArticle article, final BuildContext context) {
    DatabaseService.update(article.id!, article.asMap, getCollectionInstance(context));
  }

  static CollectionReference getCollectionInstance(final BuildContext context) {
    return HouseholdService.getSelectedHousehold(context).collection("shopping_list");
  }

  static delete(final String articleId, final BuildContext context) {
    DatabaseService.delete(articleId, getCollectionInstance(context));
  }

  static Future<List<ShoppingArticle>> getOrderBy(final String field, final BuildContext context) async {
    List<ShoppingArticle> articles = [];
    return getCollectionInstance(context).orderBy(field).get().then((querySnapshot) {
      querySnapshot.docs.forEach((document) => articles.add(ShoppingArticle.fromDocument(document)));
      return articles;
    });
  }

  static Future<List<ShoppingArticle>> getOnlyCheckedArticle(BuildContext context) async {
    List<ShoppingArticle> articles = [];
    return getCollectionInstance(context).where('checked', isEqualTo: true).get().then((querySnapshot) {
      querySnapshot.docs.forEach((document) => articles.add(ShoppingArticle.fromDocument(document)));
      return articles;
    });
  }

  static Query getByCategory(final BuildContext context, final Category category) {
    return getCollectionInstance(context).where('category', isEqualTo: category.category);
    //.orderBy('checked');
  }
}
