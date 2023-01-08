import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_fridge/model/category.dart';
import 'package:my_fridge/model/cooking_recipe.dart';
import 'package:my_fridge/services/user_service.dart';
import 'package:provider/provider.dart';

import 'database.dart';

class CookingRecipeService {
  static CollectionReference getCollectionInstance(final BuildContext context) {
    return context.read<UserService>().currentUserDocument(context).collection("cooking_recipe");
  }

  static create(final CookingRecipe cookingRecipe, final BuildContext context) {
    DatabaseService.createWithId(cookingRecipe.name, cookingRecipe.asMap, getCollectionInstance(context));
  }

  static update(final CookingRecipe cookingRecipe, final BuildContext context) {
    DatabaseService.update(cookingRecipe.id!, cookingRecipe.asMap, getCollectionInstance(context));
  }

  static delete(final String userId, final BuildContext context) {
    DatabaseService.delete(userId, getCollectionInstance(context));
  }

  static Future<List<CookingRecipe>> get(final String? searchFilter, final BuildContext context) async {
    List<CookingRecipe> articles = [];
    if (searchFilter == null || searchFilter == '') {
      return getCollectionInstance(context).get().then((querySnapshot) {
        querySnapshot.docs.forEach((document) => articles.add(CookingRecipe.fromDocument(document)));
        return articles;
      });
    }
    return getCollectionInstance(context)
        .where('name', isGreaterThanOrEqualTo: searchFilter)
        .where('name', isLessThan: searchFilter)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((document) => articles.add(CookingRecipe.fromDocument(document)));
      return articles;
    });
  }

  static Query getByCategory(final BuildContext context, final Category category) {
    return getCollectionInstance(context).where('category', isEqualTo: category.category);
  }

  static void addCookingRecipeToShoppingList(shopp) {}
}
