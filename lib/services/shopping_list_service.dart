import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_fridge/model/category.dart';
import 'package:my_fridge/model/shopping_article.dart';
import 'package:my_fridge/services/database.dart';
import 'package:my_fridge/services/household_service.dart';

class ShoppingListService {
  static create(ShoppingItem article, BuildContext context) {
    DatabaseService.create(article.asMap, getCollectionInstance(context));
  }

  static createFromFridge(ShoppingItem article, BuildContext context) {
    DatabaseService.create(article.asMap, getCollectionInstance(context));
  }

  static update(ShoppingItem article, BuildContext context) {
    DatabaseService.update(article.id!, article.asMap, getCollectionInstance(context));
  }

  static CollectionReference getCollectionInstance(BuildContext context) {
    return HouseholdService.getSelectedHouseholdDoc(context).collection("shopping_list");
  }

  static delete(String articleId, BuildContext context) {
    DatabaseService.delete(articleId, getCollectionInstance(context));
  }

  static Future<List<ShoppingItem>> getOrderBy(String field, BuildContext context) async {
    List<ShoppingItem> articles = [];
    return getCollectionInstance(context).orderBy(field).get().then((querySnapshot) {
      querySnapshot.docs.forEach((document) => articles.add(ShoppingItem.fromDocument(document)));
      return articles;
    });
  }

  static Future<List<ShoppingItem>> getOnlyCheckedArticle(BuildContext context) async {
    List<ShoppingItem> articles = [];
    return getCollectionInstance(context).where('checked', isEqualTo: true).get().then((querySnapshot) {
      querySnapshot.docs.forEach((document) => articles.add(ShoppingItem.fromDocument(document)));
      return articles;
    });
  }

  static Query getByCategory(BuildContext context, Category category) {
    return getCollectionInstance(context).where('category', isEqualTo: category.category);
    //.orderBy('checked');
  }
}
