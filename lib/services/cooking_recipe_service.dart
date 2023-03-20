import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_fridge/model/cooking_recipe.dart';
import 'package:my_fridge/model/meal_type.dart';
import 'package:my_fridge/services/database.dart';

class CookingRecipeService {
  static final CollectionReference collectionInstance = FirebaseFirestore.instance.collection("cooking_recipe");

  static create(CookingRecipe cookingRecipe, BuildContext context) {
    DatabaseService.createWithId(cookingRecipe.name, cookingRecipe.asMap(context), collectionInstance);
  }

  static update(CookingRecipe cookingRecipe, BuildContext context) {
    DatabaseService.update(cookingRecipe.id!, cookingRecipe.asMap(context), collectionInstance);
  }

  static delete(String userId, BuildContext context) {
    DatabaseService.delete(userId, collectionInstance);
  }

  static Future<List<CookingRecipe>> get(String? searchFilter, BuildContext context) async {
    List<CookingRecipe> articles = [];
    if (searchFilter == null || searchFilter == '') {
      return collectionInstance.get().then((querySnapshot) {
        querySnapshot.docs.forEach((document) => articles.add(CookingRecipe.fromDocument(document)));
        return articles;
      });
    }
    return collectionInstance
        .where('name', isGreaterThanOrEqualTo: searchFilter)
        .where('name', isLessThan: searchFilter)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((document) => articles.add(CookingRecipe.fromDocument(document)));
      return articles;
    });
  }

  static Future<List<CookingRecipe>> getByMealType(MealType mealType) async {
    List<CookingRecipe> cookingRecipes = [];

    QuerySnapshot querySnapshot = await collectionInstance.where('mealType', isEqualTo: mealType.index).get();
    querySnapshot.docs.forEach((document) =>
        cookingRecipes.add(CookingRecipe.fromDocument(document)));
    return cookingRecipes;
  }

  //static void addCookingRecipeToShoppingList(shopp) {}
}
