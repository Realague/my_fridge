import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_fridge/model/category.dart';
import 'package:my_fridge/model/cooking_recipe.dart';
import 'package:my_fridge/services/user_service.dart';

import 'database.dart';

class CookingRecipeService {
  static CollectionReference getCollectionInstance(BuildContext context) {
    return UserService.currentUserDocument(context)
        .collection("cooking_recipe");
  }

  static create(CookingRecipe cookingRecipe, BuildContext context) {
    DatabaseService.create(
        id: cookingRecipe.name,
        data: cookingRecipe.asMap,
        collection: getCollectionInstance(context));
  }

  static update(CookingRecipe cookingRecipe, BuildContext context) {
    DatabaseService.update(
        cookingRecipe.id!, cookingRecipe.asMap, getCollectionInstance(context));
  }

  static delete(String userId, BuildContext context) {
    DatabaseService.delete(userId, getCollectionInstance(context));
  }

  static Future<List<CookingRecipe>> get(
      String? searchFilter, BuildContext context) async {
    List<CookingRecipe> articles = [];
    if (searchFilter == null || searchFilter == '') {
      return getCollectionInstance(context).get().then((querySnapshot) {
        querySnapshot.docs.forEach(
            (document) => articles.add(CookingRecipe.fromDocument(document)));
        return articles;
      });
    }
    return getCollectionInstance(context)
        .where('name', isGreaterThanOrEqualTo: searchFilter)
        .where('name', isLessThan: searchFilter)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach(
          (document) => articles.add(CookingRecipe.fromDocument(document)));
      return articles;
    });
  }

  static Query getByCategory(BuildContext context, Category category) {
    return getCollectionInstance(context)
        .where('category', isEqualTo: category.category);
  }

  static void addCookingRecipeToShoppingList(shopp) {}
}
